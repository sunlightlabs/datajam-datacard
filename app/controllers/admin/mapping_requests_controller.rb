class Admin::MappingRequestsController < Admin::MappingsBaseController
  before_filter :find_mapping
  before_filter :find_endpoint

  def new
    # render
  end

  def create
    @mapping_request = MappingRequest.prepare(@mapping, @endpoint, params[:request] || {})
    
    begin
      @mapping_response = @mapping_request.perform!
      redirect_to admin_mapping_response_path(params[:mapping_id], @mapping_response.id)
      return
    rescue MappingRequest::Error => err
      flash[:error] = err.to_s
    end

    render 'new'
  end

  private

  def find_endpoint
    @endpoint = @mapping.endpoints[params[:endpoint_id].to_sym]
    raise ActionController::RoutingError.new("Not found") unless @endpoint
  end
end
