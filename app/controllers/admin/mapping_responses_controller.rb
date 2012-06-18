class Admin::MappingResponsesController < AdminController
  def show
    @mapping_response = MappingResponse.find(params[:id])
    @preview_data = @mapping_response.data
    render
  end
end
