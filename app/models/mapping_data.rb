class MappingData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :source, type: Array

  has_one :request, class_name: "MappingRequest", inverse_of: :datum
  has_one :dataset, as: :datasetable
end
