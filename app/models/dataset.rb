class Dataset
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String

  #has_many :cards, class_name: "DataCard", inverse_of: :dataset, dependent: :destroy
  belongs_to :data, polymorphic: true, inverse_of: :dataset
end
