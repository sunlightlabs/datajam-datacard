require 'hashie/mash'

class Admin::CardsController < AdminController
  before_filter :find_or_initialize_card, :except => [:index, :create]
  before_filter :load_data_set, :only => [:new]
  before_filter :set_form_type, :except => [:index, :destroy]
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
    @card.data_set.sourced = "#{@from.to_s.titleize}Data".constantize.new if @card.data_set.new_record?
  end

  def edit
  end

  def create
    @card = DataCard.new(params[:card])
    load_mappings
    if @card.save
      flash[:success] = "Card saved."
      redirect_to admin_card_path(@card)
    else
      flash[:error] = @card.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def update
    if @card.update_attributes(params[:card])
      flash[:success] = "Card updated."
      redirect_to admin_card_path(@card)
    else
      flash[:error] = @card.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  def destroy
    if @card.data_set_id && (@card.data_set.cards.length == 1 rescue false)
      success = @card.data_set.sourced.destroy
    else
      success = @card.destroy
    end
    if success
      flash[:success] = "Card deleted."
    else
      flash[:error] = @card.errors.full_messages.to_sentence
    end
    redirect_to admin_cards_path
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
      if @card.data_set
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

end
