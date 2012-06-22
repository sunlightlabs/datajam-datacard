class Admin::CardsFromMappingResponsesController < AdminController

  before_filter :find_mapping_response

  def new
    @card = DataCard.new(params[:card])
    @card.response = @mapping_response
  end

  def create
    @card = DataCard.new(params[:card])
    @card.response = @mapping_response

    if @card.save
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

end
