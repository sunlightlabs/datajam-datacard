class CsvData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :source, type: String

  has_one :dataset, as: :datasetable
end
