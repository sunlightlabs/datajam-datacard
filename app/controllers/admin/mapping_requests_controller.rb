class Admin::MappingRequestsController < AdminController
  before_filter :find_mapping
  before_filter :find_endpoint

  def new
    # render
  end

  def create
  end

  private

  def find_mapping
    @mapping = Datajam::Datacard.mappings.find_by_klass(params[:mapping_id])
    raise ActionController::RoutingError.new("Not found") unless @mapping
  end

  def find_endpoint
    @endpoint = @mapping.endpoints[params[:endpoint_id].to_sym]
    raise ActionController::RoutingError.new("Not found") unless @endpoint
  end
end
