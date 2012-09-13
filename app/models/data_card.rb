class DataCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  include Tag::Taggable

  # Used for auto-routing
  def self.model_name
    ActiveModel::Name.new(self, nil, "Card")
  end

  def self.graphy_display_types
    [:column_chart]
  end

  field :title,           type: String
  field :source,          type: String
  field :html,            type: String
  field :display_type,    type: Symbol
  field :group_by,        type: Symbol
  field :series,          type: Array

  belongs_to :data_set

  validates_associated :data_set
  validates_presence_of :title
  validates_presence_of :group_by, if: is_graphy?
  validates_presence_of :series, if: is_graphy?
  validates_format_of :display_type, in: [:table].push(DataCard.graphy_display_types)
  validate :ensure_series_values_are_numeric, if: is_graphy?

  before_save :render
  after_save :save_events
  after_destroy :save_events

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    id.to_s
  end

  def is_graphy?
    DataCard.graphy_display_types.include?(display_type)
  end

  def render
    template = "datajam/datacard/#{type.to_s}"
    self.html = renderer.render(template, locals: {data: data_set.as_json} )
  end

  def renderer
    @@av ||= ActionView::Base.new(Datajam::Datacard::Engine.paths['app/views'].first)
  end

  protected

  def save_events
    Event.all.each(&:save)
  end

  private

  def ensure_series_values_are_numeric
    series.each do |field|
      csvdata = data_set.as_csv
      fields = csvdata.readline
      idx = fields.index(field)
      unless data_set.readline[idx] =~ /^[\d]+$/
        errors.add(:series, 'must contain only numeric fields')
      end
    end
  end

end
