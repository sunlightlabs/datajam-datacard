class Admin::MappingSettingsController < AdminController
  before_filter :find_mapping
  before_filter :find_mapping_settings

  def edit
  end

  def update
    if @mapping_settings.update_attributes(params[:mapping_settings])
      flash[:success] = "Settings updated."
      redirect_to admin_mappings_path
    else
      flash[:error] = @cards.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  private

  def find_mapping
    @mapping = Datajam::Datacard.mappings.find_by_klass(params[:mapping_id])
    raise ActionController::RoutingError.new("Not found") unless @mapping
  end

  def find_mapping_settings
    @mapping_settings = @mapping.persisted_settings
  end
end
