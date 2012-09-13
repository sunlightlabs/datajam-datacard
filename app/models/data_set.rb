require 'base64'

class DataSet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name,      type: String
  field :data,      type: Binary
  field :source,    type: String

  belongs_to :sourced, polymorphic: true
  has_many :cards, class_name: "DataCard", inverse_of: :data_set, dependent: :destroy

  def as_json
    data
  end

  def as_csv
    @csv ||= CSV.load(data)
  end

end