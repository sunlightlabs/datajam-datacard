require 'json'

class MappingData
  class Error < StandardError
  end

  include Mongoid::Document
  include Mongoid::Timestamps

  field :mapping_id,    type: String
  field :endpoint_name, type: Symbol
  field :params,        type: Hash

  has_many :data_sets, as: :sourced, dependent: :destroy

  attr_accessor :mapping

  # def self.prepare(mapping, endpoint, params = {})
  #   new(:mapping_id => mapping.id,
  #       :endpoint_name => endpoint.name,
  #       :params => params,
  #       :mapping => mapping)
  # end

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

    data = mapping.process_response resp

    if !data || !data.length
      raise Error, "Couldn't parse the response or returned json was empty"
    end

    data = JSON.load(data) || []
    arr = []
    data.each do |row|
      record = {}
      row.each do |k,v|
        begin
          puts k, v
          field_name = endpoint.response.fields[k.to_sym].label
          record[field_name] = endpoint.response.fields[k.to_sym].value_reader.call v
        rescue
          nil
        end
      end
      arr.push record
    end

    JSON.dump(arr)
  end
end
