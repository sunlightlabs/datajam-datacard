class Admin::MappingRequestsController < Admin::MappingsBaseController
  before_filter :find_mapping
  before_filter :find_endpoint

  def new
    # render
  end

  def create
    @response = @mapping.request(@endpoint.name, params[:request]) || {}

    if @response.status >= 400
      flash[:error] = @response.body
    elsif @preview_data = @response.env[:csv] and !@preview_data.rows.empty?
      @mapping_response = MappingResponse.create(:data => @preview_data)
      redirect_to admin_mapping_response_path(params[:mapping_id], @mapping_response.id)
      return
    else
      flash[:error] = "Couldn't parse the response or returned table was empty"
    end

    render 'new'
  end

  private

  def find_endpoint
    @endpoint = @mapping.endpoints[params[:endpoint_id].to_sym]
    raise ActionController::RoutingError.new("Not found") unless @endpoint
  end
end
