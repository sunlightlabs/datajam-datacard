class DataCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  include Tag::Taggable

  def self.model_name
    ActiveModel::Name.new(self, nil, "Card")
  end

  field :title,      type: String
  field :html,       type: String
  field :group_by,   type: String
  field :series,     type: String
  field :display_as, type: String # html, columns_chart, table

  belongs_to :dataset, inverse_of: :card
  
  validates_presence_of :title

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end
end
