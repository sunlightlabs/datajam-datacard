class MappingRequest
  class Error < StandardError
  end

  include Mongoid::Document
  include Mongoid::Timestamps

  field :mapping_id,    type: String 
  field :endpoint_name, type: String
  field :params,        type: Hash

  has_many :datum, class_name: "MappingData", inverse_of: :request
  #has_many :responses, class_name: "MappingResponse", inverse_of: :request
  
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

  def perform_request
    params = self.params.merge(mapping.persisted_settings.settings)
    resp = mapping.request(endpoint_name.to_sym, params)
    (resp.status < 400 and resp.env[:data]) or raise Error, resp.body
  end

  def perform!
    self.datum.build(:source => perform_request).tap do |mapping_data|
      self.save!
      mapping_data.save!
    end
  end

  def perform_for!(mapping_data)
    mapping_data.update_attributes!(:source => perform_request)
  end
end
