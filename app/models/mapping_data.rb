class MappingData
  class Error < StandardError
  end

  include Mongoid::Document
  include Mongoid::Timestamps

  field :mapping_id,    type: String
  field :endpoint_name, type: String
  field :params,        type: Hash

  has_many :data_sets, as: :sourced

  attr_accessor :mapping

  def self.prepare(mapping, endpoint, params = {})
    new(:mapping_id => mapping.id,
        :endpoint_name => endpoint.name,
        :params => params,
        :mapping => mapping)
  end

  def mapping
    @mapping ||= Datajam::Datacard.mappings.find_by_klass(mapping_id)
  end

  def perform!(forced = nil)
    params = self.params.merge(mapping.persisted_settings.settings)
    resp = mapping.request(endpoint_name.to_sym, params)
    raise Error, @response.body if resp.status >= 400

    data = resp.env[:json]

    if !data || !data.rows.empty?
      raise Error, "Couldn't parse the response or returned json was empty"
    end

    data
  end
end
