require 'json'
require 'datajam/datacard/api_mapping/input_field'

class MappingData
  class Error < StandardError
  end

  include Mongoid::Document
  include Mongoid::Timestamps

  field :mapping_id,    type: String
  field :endpoint_name, type: Symbol
  field :params,        type: Hash,   default: {}

  has_many :data_sets, as: :sourced, dependent: :destroy

  attr_accessor :mapping

  before_validation :set_param_values
  validate :check_mapping_values

  def mapping
    @mapping ||= Datajam::Datacard.mappings.find_by_klass(mapping_id)
  end

  def endpoint
    mapping.endpoints[endpoint_name]
  end

  def data_type
    mapping.data_type
  end

  def perform!(forced = nil)
    params = self.params.merge(mapping.persisted_settings.settings)
    resp = mapping.request(endpoint_name.to_sym, params)
    raise Error, resp.body if resp.status >= 400

    data = endpoint.response.before_filter.call resp

    if !data || !data.length
      raise Error, "Couldn't parse the response or returned json was empty"
    end

    data = JSON.load(data) || []
    arr = []
    data.each do |row|
      record = {}
      row.each do |k,v|
        begin
          field_name = endpoint.response.fields[k.to_sym].label
          record[field_name] = endpoint.response.fields[k.to_sym].value_getter.call v
        rescue
          nil
        end
      end
      arr.push record
    end

    JSON.dump(arr)
  end

  protected

  def set_param_values
    params.each do |k,v|
      field = endpoint.params[k.to_sym]
      value = field.value_setter.call(v)
      self.params[k] = value
    end
  end

  def check_mapping_values
    invalid_fields = {}
    params.each do |k,v|
      field = endpoint.params[k.to_sym]
      field.validators.each do |validator|
        invalid_fields[k] = field.label unless validator.call(v) || invalid_fields.keys.include?(k)
      end
    end
    if invalid_fields.any?
      message = "Some fields were invalid or not found: #{invalid_fields.values.join(', ')}."
      if invalid_fields.keys.include? "entity_id"
        message += " Try looking up an ID number for #{invalid_fields['entity_id']} at http://influenceexplorer.com."
        errors.add(:base, message)
      end
    end
  end
end
