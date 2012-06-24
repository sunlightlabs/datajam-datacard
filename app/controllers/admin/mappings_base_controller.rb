class Admin::MappingsBaseController < AdminController
  protected

  def find_mapping
    @mapping = Datajam::Datacard.mappings.find_by_klass(params[:mapping_id])
    raise ActionController::RoutingError.new("Not found") unless @mapping
  end
end
