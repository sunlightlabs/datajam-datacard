class Admin::MappingsController < ::Datajam::Datacard::EngineController
  before_filter :load_mappings, only: [:index]

  def index
  end
end