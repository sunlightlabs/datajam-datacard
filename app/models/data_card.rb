class DataCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  include Tag::Taggable
  include RendersTemplates

  # Used for auto-routing
  def self.model_name
    ActiveModel::Name.new(self, nil, "Card")
  end

  def self.display_types
    [:table, :html].push(DataCard.graphy_display_types).flatten
  end

  def self.graphy_display_types
    [:column_chart]
  end

  field :title,               type: String
  field :source,              type: String
  field :html,                type: String
  field :display_type,        type: Symbol
  field :group_by,            type: String
  field :sort_by,             type: String
  field :sort_order,          type: Symbol
  field :series,              type: Array
  field :limit,               type: Integer
  field :cached_tag_string,   type: String

  index :title
  index :source
  index :html
  index :cached_tag_string

  default_scope order_by(title: :asc)

  belongs_to :data_set, autosave: true
  accepts_nested_attributes_for :data_set

  before_validation do
    self.display_type = display_type.to_sym if display_type.present?
  end

  validates_associated :data_set, unless: :is_html?
  validates_presence_of :title
  validates_presence_of :group_by, if: :is_graphy?
  validates_presence_of :series, unless: :is_html?
  validates_numericality_of :limit, allow_nil: true
  validates_inclusion_of :display_type, in: DataCard.display_types
  validates_inclusion_of :sort_order, in: [:ascending, :descending], allow_nil: true

  before_save :cache_tags
  after_save :render
  after_save :save_events
  after_destroy :save_events

  alias_method :_source, :source

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    id.to_s
  end

  def source
    _source || data_set.sourced.mapping.name rescue nil
  end

  def is_html?
    display_type == :html
  end

  def is_graphy?
    ::DataCard.graphy_display_types.include?(display_type)
  end

  def is_table?
    display_type == :table
  end

  def from_mapping?
    data_set.sourced_type == 'MappingData' rescue false
  end

  def from_csv?
    data_set.sourced_type == 'CsvData' rescue false
  end

  def has_siblings?
    data_set && data_set.cards.length > 1
  end

  def siblings
    data_set && data_set.cards.entries.reject{|card| card.id == id }
  end

  def series_string=(ser)
    if ser.is_a? String
      ser = ser.split(/, ?/)
    end
    self.series = ser
  end

  def series_string
    series.join(', ') rescue ''
  end

  def data_options
    {
      sort_by: sort_by,
      sort_order: sort_order,
      limit: limit,
      group_by: group_by,
      fields: series
    }.keep_if{|k,v| v.present? }
  end

  def prepared_data(format, options={})
    options = data_options.clone.merge(options)
    data_set.send("as_#{format.to_s}".to_sym, options)
  end

  def render
    return html if display_type == :html

    template = "datajam/datacard/data_cards/#{display_type.to_s}"
    self.set(:html, render_to_string(partial: template, locals: { card: self }))
  end

  protected

  def cache_tags
    self.cached_tag_string = tag_string
  end

  def save_events
    Event.all.each(&:save)
  end

  def ensure_series_values_are_numeric
    row = data_set.as_json[0]
    series.each do |field|
      unless row[field].to_s =~ /^[\d\.,]+$/
        errors.add(:series, 'must contain only numeric fields')
      end
    end
  end
end

# FIXME: This seems to fail when run in an initializer or RendersTemplates' after_initialize hook
RendersTemplates::DummyController.class_eval do
  helper 'datajam/datacard/data_cards'
end
