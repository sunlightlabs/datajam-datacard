class Datajam::Datacard::EngineController < ::AdminController

protected

  def load_mappings
    @mappings = Datajam::Datacard.mappings
  end

  def find_mapping
    @mapping = Datajam::Datacard.mappings.find_by_klass(params[:mapping_id])
    raise ActionController::RoutingError.new("Not found") unless @mapping
  end

end