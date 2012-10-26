class Admin::MappingsController < Admin::MappingBaseController
  before_filter :load_mappings, only: [:index]

  def index
  end
end