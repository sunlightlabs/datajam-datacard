class MappingRequest
  class Error < StandardError
  end

  include Mongoid::Document
  include Mongoid::Timestamps

  field :mapping_id,    type: String 
  field :endpoint_name, type: String
  field :params,        type: Hash

  has_many :responses, class_name: "MappingResponse", inverse_of: :request
  
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
    
    data = resp.env[:csv]
    
    if data && !data.rows.empty?
      if forced
        return forced.tap do
          forced.data = data
          forced.save!
        end
      else
        response = self.responses.build(:data => data)
        self.save!
        response.save!
        return response
      end
    else
      raise Error, "Couldn't parse the response or returned table was empty"
    end
  end
end
