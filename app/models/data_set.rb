require 'base64'

class DataSet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :data, type: Binary

  has_many :cards, class_name: "DataCard", inverse_of: :data_set, dependent: :destroy
  belongs_to :sourced, polymorphic: true, autosave: true
  accepts_nested_attributes_for :sourced

  before_save :load_data
  after_save :render_cards

  def name
    sourced.name
  end

  def load_data
    return unless sourced
    loader = "from_#{sourced.data_type.to_s}".to_sym
    if sourced.respond_to? :perform!
      self.data = Base64.encode64(Marshal.dump(self.send(loader, sourced.perform!)))
    else
      self.data = Base64.encode64(Marshal.dump(self.send(loader, sourced.data)))
    end
  end

  def as_json(options={})
    arr = get_data
    if options[:group_by].present?
      grouped = []
      indices = {}
      metric = options[:group_by].to_s
      arr.each do |obj|
        indices[obj[metric]] ||= grouped.length
        index = indices[obj[metric]]
        grouped[index] ||= {group: obj[metric], series: {}}
        options[:fields].each do |field|
          grouped[index][:series][field.to_s] ||= 0
          grouped[index][:series][field.to_s] += obj[field.to_s].to_f rescue 0
        end
      end
      arr = grouped
      if options[:sort_by].present? && options[:fields].include?(options[:sort_by])
        arr.each do |row|
          metric = options[:sort_by].to_s
          if metric == options[:group_by].to_s
            arr.sort_by!{|obj| obj[:group]}
          else
            arr.sort_by!{|obj| obj[:series][metric]}
          end
        end
      end
    else
      if options[:sort_by].present?
        metric = options[:sort_by].to_s
        arr.sort_by!{|obj| obj[metric] }
      end
      if options[:fields].present?
        arr = arr.collect do |row|
          row.keep_if{|k,v| options[:fields].include? k.to_s}
        end
      end
    end
    if options[:sort_order] == :descending
      arr.reverse!
    end
    if options[:limit].present?
      arr = arr[0..(options[:limit] - 1)]
    end
    arr
  end

  def to_json(options={})
    JSON.dump(as_json(options))
  end

  def as_csv(options={})
    arr = as_json(options)
    rows = []
    if options[:group_by].present?
      keys = arr[0][:series].keys
      rows[0] = [options[:group_by]] + keys
      arr.each do |row|
        rows << [row[:group]] + keys.collect{|k| row[:series][k]}  # Makes sure values are in order
      end
    else
      rows << arr[0].keys
      arr.each do |row|
        rows << row.values
      end
    end
    rows
  end

  def to_csv(options = {})
    options[:sep] ||= ','
    sep = options.pop(:sep)
    as_csv(options).collect do |row|
      row.join(sep)
    end.join("\n")
  end

  def sourced_attributes=(attributes)
    self.sourced = sourced_type.constantize.find_or_initialize_by(id: sourced_id)
    self.sourced.update_attributes(attributes)
    self.sourced_id = self.sourced.id
  end

  protected

  def render_cards
    self.cards.each(&:render)
  end

  private

  def get_data
    Marshal.load(Base64.decode64(data))
  end

  def from_json(json)
    JSON.parse(json)
  end

  def from_csv(csv)
    parsed = CSV.parse(csv)
    keys = parsed.shift
    vals = parsed
    vals.collect do |row|
      row = Hash[*keys.zip(row).flatten]
    end
  end

  def from_xml(xml)
    # Using this is kind of a terrible idea, just fyi.
    Hash.from_xml(xml)
  end

end