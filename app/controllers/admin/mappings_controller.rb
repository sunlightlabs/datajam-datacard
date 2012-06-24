class Admin::MappingsController < Admin::MappingsBaseController
  def index
    @mappings = Datajam::Datacard.mappings
  end

  def show
    params[:mapping_id] = params[:id]
    find_mapping
  end
end
