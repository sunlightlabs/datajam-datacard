class DataCard
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  include Tag::Taggable

  # Used for auto-routing
  def self.model_name
    ActiveModel::Name.new(self, nil, "Card")
  end

  field :title,             type: String
  field :table_head,        type: Array,     default: []
  field :table_body,        type: Array,     default: []
  field :csv,               type: String
  field :source,            type: String
  field :body,              type: String
  field :cached_tag_string, type: String

  has_many :graphs, class_name: "DataCardGraph", inverse_of: :card, dependent: :destroy

  attr_accessor :response_fields
  attr_accessor :response

  validates_presence_of :title

  before_save :read_uploaded_csv, :cache_tags
  before_save :parse_csv
  before_create :read_from_response
  before_create :write_csv_if_none
  after_save :save_events
  after_destroy :save_events

  mount_uploader :csv_file, CsvUploader

  index :title => 1
  index :csv => 1
  index :body => 1
  index :source => 1
  index :cached_tag_string => 1

  default_scope order_by(title: :asc)

  # Mongoid::Slug changes this to `self.slug`. Undo that.
  def to_param
    self.id.to_s
  end

  def render
    Handlebars.compile(template).call(self)
  end

  def template
    return body if body.present?

    return <<-TMPL.strip_heredoc
    <h3>{{ title }}</h3>
    <table class="table table-striped table-hover">

      <thead>
          <tr id="titles">
              {{#each table_head}}
              <th>{{this}}</th>
              {{/each}}
          </tr>
      </thead>

      <tbody>
      {{#each table_body}}
      <tr>
          {{#each this}}
          <td>{{this}}</td>
          {{/each}}
      </tr>
      {{/each}}
      </tbody>

    </table>

    <br/>
    {{#if source}}
    <div class="source">Source: {{{source}}}</div>
    {{/if}}
    TMPL
  end

  def graph_data_for(group_by, series)
    return if series.empty?
    group_by_id = table_head.index(group_by.to_s) or return

    data = series.map do |key|
      serie_id = table_head.index(key.to_s) or next
      values   = pick_values_for(serie_id, group_by_id)

      { key: key, values: values }
    end

    data.compact!
    data unless data.empty?
  end

  def rebuild_table_data!
    read_uploaded_csv
    parse_csv

    unless persisted?
      read_from_response
      write_csv_if_none
    end
  end

  protected

  def cache_tags
    self.cached_tag_string = tag_string
  end

  def pick_values_for(serie_id, group_by_id)
    table_body.inject({}) do |res, row|
      y = row[serie_id].to_f_if_possible
      x = row[group_by_id].to_f_if_possible

      res[x] = 0 unless res[x]
      res[x] += (y.is_a?(String) ? 1 : y)
      res
    end.map { |x,y| {x: x, y: y} }
  end

  def read_uploaded_csv
    return if csv_file.blank?
    self.csv = csv_file.read
  end

  def parse_csv
    return if csv.to_s.blank?
    parsed = CSV.parse(self.csv)
    self.table_head = parsed.first
    self.table_body = parsed.slice(1, parsed.length)
  rescue CSV::MalformedCSVError => err
    errors[:csv_file] << "Invalid CSV file: #{err.message}"
  end

  def save_events
    Event.all.each(&:save)
  end

  def read_from_response
    return if response.nil?
    self.table_head = response_fields
    indexes = response_fields.map { |head| response.data.headers.index(head) }
    body = response.data.rows.map { |row| indexes.map { |i| row[i] } }
    self.table_body = body
  end

  def write_csv_if_none
    return if self.csv or self.body

    self.csv = CSV.generate({}) do |csv|
      csv << self.table_head if self.table_head
      self.table_body.each { |row| csv << row }
    end.to_s
  end
end
