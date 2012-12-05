require 'hashie/mash'

class Admin::CardsController < AdminController
  before_filter :find_or_initialize_card, :except => [:index, :create]
  before_filter :load_data_set, :only => [:new]
  before_filter :set_form_type, :except => [:index, :destroy, :detach]
  before_filter :load_mappings, :only => [:new, :edit]
  before_filter :prepare_mapping_params, :only => [:edit]

  def index
    @cards = DataCard.unscoped.all.order(:updated_at => :desc)
    @cards = DataCard.where(data_set_id: params[:data_set_id]) if params[:data_set_id].present?
    @cards = filter_and_sort @cards
    render_if_ajax 'admin/cards/_table'
  end

  def show
  end

  def new
    @card.data_set.sourced = "#{@from.to_s.titleize}Data".constantize.new if @card.data_set && @card.data_set.new_record?
  end

  def edit
  end

  def create
    @card = DataCard.new(params[:card])
    load_mappings
    if @card.has_siblings? && params[:update_data].nil? && @card.from_mapping?
      params[:card].delete(:data_set_attributes)
    end
    if @card.save
      flash[:success] = "Card saved."
      redirect_to admin_card_path(@card)
    else
      cascade_errors(@card, :data_set, :sourced)
      @mapping = @card.data_set.sourced.mapping rescue nil
      @endpoint = @card.data_set.sourced.endpoint rescue nil
      render 'new'
    end
  end

  def update
    params[:card].delete(:data_set_attributes) unless (params[:update_data].present? && @card.from_mapping?)
    if @card.update_attributes(params[:card])
      flash[:success] = "Card updated."
      redirect_to admin_card_path(@card)
    else
      cascade_errors(@card, :data_set, :sourced)
      @mapping = @card.data_set.sourced.mapping
      @endpoint = @card.data_set.sourced.endpoint
      render 'edit'
    end
  end

  def destroy
    if @card.data_set_id && !@card.has_siblings?
      success = @card.data_set.sourced.destroy
    else
      success = @card.destroy
    end
    if success
      flash[:success] = "Card deleted."
    else
      cascade_errors(@card, :data_set)
      redirect_to :back
    end
    redirect_to admin_cards_path
  end

  def to_csv
    sourced_id = @card.data_set.sourced.id
    @card.data_set.sourced = CsvData.new(data: @card.data_set.to_csv(@card.data_options), source: @card.source)
    if @card.data_set.save
      mapping = MappingData.find(sourced_id)
      mapping.set(:data_sets, [])
      mapping.destroy
      flash[:success] = "Card(s) converted to CSV."
      redirect_to edit_admin_card_path(@card)
    else
      cascade_errors(@card, :data_set, :sourced)
      redirect_to :back
    end
  end

  def to_html
    data_set = @card.data_set
    destroy_data_set = (data_set.cards.length <= 1)
    if @card.update_attributes(data_set: nil, display_type: :html)
      data_set.sourced.destroy if destroy_data_set
      flash[:success] = "Card(s) converted to HTML."
      redirect_to edit_admin_card_path(@card)
    else
      cascade_errors(@card, :data_set)
      redirect_to :back
    end
  end

  protected

  def find_or_initialize_card
    if params[:id].present?
      @card = DataCard.find(params[:id])
    else
      @card = DataCard.new
    end
  end

  def load_data_set
    return if @from == :html || (params[:from].present? && params[:from].to_sym == :html)
    @card.data_set ||= params[:data_set_id].present? ? DataSet.find(params[:data_set_id]) : DataSet.new
  end

  def set_form_type
    @from = :html
    if params[:from].present?
      @from = params[:from].to_sym
    elsif @card && (@card.data_set.persisted? rescue false)
      if @card.from_csv?
        @from = :csv
      elsif @card.from_mapping?
        @from = :mapping
      end
    end rescue nil
  end

  def load_mappings
    @mappings = Datajam::Datacard.mappings
    return unless @from == :mapping
    if @card.new_record?
      if @card.data_set && @card.data_set.persisted?
        @mapping ||= @card.data_set.sourced.mapping
        @endpoint ||= @card.data_set.sourced.endpoint
      elsif params[:mapping_id].present?
        @mapping ||= @mappings.find_by_klass(params[:mapping_id])
        @endpoint ||= @mapping.endpoints[params[:endpoint].to_sym]
      end
    else
      @mapping ||= @card.data_set.sourced.mapping rescue nil
      @endpoint ||= @mapping.endpoints[@card.data_set.sourced.endpoint_name] rescue nil
    end
  end

  def prepare_mapping_params
    return unless @card.from_mapping?
    @card.data_set.sourced.params = Hashie::Mash.new(@card.data_set.sourced.params)
  end

  def cascade_errors(*args)
    stack = args.first
    args[1..-1].each do |arg|
      pushed = stack.send arg
      if pushed.nil? || !pushed.errors.any?
        break
      else
        stack = pushed
      end
    end
    flash[:error] = stack.errors.full_messages.to_sentence
  end

end
