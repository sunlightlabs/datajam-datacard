class Admin::MappingsController < AdminController
  def index
    @mappings = Datajam::Datacard.mappings
  end
end
