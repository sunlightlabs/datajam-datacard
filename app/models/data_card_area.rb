class DataCardArea < ContentArea
  include RendersTemplates

  def self.modal_class
    "Datajam.Datacard.views.Modal"
  end

  field :data_cards, type: Array
  field :current_card_id, type: String

  before_create :set_cards
  before_save :set_cards
  before_save :set_current_card

  def current_card
    self.current_card_id ? DataCard.find(self.current_card_id) : nil rescue nil
  end

  def set_cards
    self.data_cards = event.filter_by_tags(DataCard.all).map do |card|
      { id: card.id, title: card.title }
    end
  end

  def set_current_card
    unless self.data.nil? || self.data['current_card_id'].nil?
      self.current_card_id = self.data['current_card_id']
      self.html = self.render
    end
  end

  def render_head
    render_to_string :partial => 'datajam/datacard/data_card_areas/head_assets'
  end

  def render_body
    render_to_string :partial => 'datajam/datacard/data_card_areas/body_assets'
  end

  def render
    render_to_string(
      :partial => 'datajam/datacard/data_card_areas/content', :locals  => { :data_card => self.current_card, :data_card_area => self }
    )
  end

  def render_update
    r = "<h2>Card Not Yet Selected</h2>"
    r = self.current_card.html if self.current_card rescue r
  end

end
