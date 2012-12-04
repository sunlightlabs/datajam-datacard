require 'csv'

class CsvData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :data, type: String
  field :source, type: String
  mount_uploader :data_file, Datajam::Datacard::CsvUploader
  has_one :data_set, as: :sourced, dependent: :destroy

  before_validation :parse_uploaded_file
  validate do
    begin
      CSV.parse(data)
    rescue CSV::MalformedCSVError => err
      self.errors.add :data, "Invalid CSV: #{err.message}"
      return false
    end
    true
  end
  before_save :destroy_uploaded_file

  def data_type
    :csv
  end

  protected

  def parse_uploaded_file
    # FIXME: Carrierwave deletion sucks, this probably leaves orphaned db cruft.
    if data_file.present?
      self.data = data_file.read rescue self.data
    end
    return true
  end

  def destroy_uploaded_file
    data_file.remove!
    self.data_file = nil
  end
end
