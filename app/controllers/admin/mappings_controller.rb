class Admin::MappingsController < AdminController
  def index
    @mappings = Datajam::Datacard.mappings
  end

  def show
    @mapping = Datajam::Datacard.mappings.find_by_klass(params[:id])
    raise ActionController::RoutingError.new("Not found") unless @mapping
  end
end
