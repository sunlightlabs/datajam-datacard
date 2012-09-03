class Admin::CardsFromMappingResponsesController < AdminController
  before_filter :find_mapping_response
  before_filter :assign_response_fields
  before_filter :init_card

  def new
  end

  def create
    if @card.save && @mapping_response.save
      flash[:success] = "Card saved."
      redirect_to admin_cards_path
    else
      flash[:error] = @card.errors.full_messages.to_sentence
      render 'new'
    end
  end

  protected

  def find_mapping_response
    @mapping_response = MappingResponse.find(params[:response_id])
  end

  def assign_response_fields
    parent = @mapping_response.parent or return
    @response_fields = parent.card.response_fields if parent.card
  end

  def init_card
    @card = DataCard.new(params[:card])
    @card.response = @mapping_response
    @card.response_fields = @response_fields if @response_fields
  end
end
