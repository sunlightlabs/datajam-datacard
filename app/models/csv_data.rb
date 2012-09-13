class CsvData
  include Mongoid::Document
  include Mongoid::Timestamps

  field: data

  has_one :data_set, as: :sourced

  mount_uploader :csv_file, CsvUploader