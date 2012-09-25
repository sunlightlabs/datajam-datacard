class DataCardGraph
  include Mongoid::Document
  include Mongoid::Timestamps

  def self.model_name
    ActiveModel::Name.new(self, nil, "CardGraph")
  end

  field :cached_data, type: Hash,  default: {}
  field :series,      type: Array, default: []
  field :group_by,    type: String

  belongs_to :card, class_name: "DataCard", inverse_of: "graphs"

  validate do |graph| 
    graph.must_be_grouped
    graph.must_have_series
  end

  before_create :cache_data

  def must_have_series
    errors.add(:series, "for X axis can't be empty") if series.to_a.empty?
  end

  def must_be_grouped
    errors.add(:group_by, "column must be specified for Y axis") if group_by.to_s.blank?
  end

  def must_have_data
    unless cached_data
      errors.add(:graph, "couldn't be generated")
      return false
    end

    true
  end

  protected
  
  def cache_data
    self.cached_data = self.card.graph_data_for(group_by, series)
    return false unless must_have_data
  end
end
