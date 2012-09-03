class Admin::CardDatasetUpdatesController < AdminController
  before_filter :find_card
  before_filter :find_mapping_response_and_request

  def new
  end

  def create
    if params[:force]
      @mapping_response.update!
      @card.recreate!
      flash[:success] = "Dataset updated."
      redirect_to admin_cards_path
    else
      parent_response = @mapping_response
      @mapping_response = @mapping_request.perform!
      @mapping_response.parent = parent_response
      @mapping_response.save!
      redirect_to new_admin_mapping_response_card_path(@mapping_request.mapping.id, @mapping_response.id)
    end
  rescue MappingRequest::Error => err
    flash[:error] = err.to_s
    render 'new'
  end

  private

  def find_card
    @card = DataCard.find(params[:id])
  end

  def find_mapping_response_and_request
    @mapping_response = @card.response
    @mapping_request = @mapping_response.request
  end
end
