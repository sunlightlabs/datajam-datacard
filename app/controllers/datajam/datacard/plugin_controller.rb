module Datajam
  module Datacard
    class PluginController < ::ApplicationController
      before_filter :authenticate_user!

      def install
        begin
          Datajam::Datacard::InstallJob.perform
          flash[:notice] = "Plugin installed."
          redirect_to admin_plugin_path('datajam-datacard')
        rescue
          flash[:error] = "Failed to install plugin: #{$!}"
          redirect_to admin_plugins_path
        end
      end

      def uninstall
        begin
          Datajam::Datacard::UninstallJob.perform
          flash[:notice] = "Plugin uninstalled."
          redirect_to admin_plugins_path
        rescue
          flash[:error] = "Failed to uninstall plugin: #{$!}"
          redirect_to admin_plugin_path('datajam-datacard')
        end
      end

      def refresh_assets
        begin
          Datajam::Datacard::RefreshAssetsJob.perform
          flash[:notice] = "Assets refreshed."
        rescue
          flash[:error] = "Failed to refresh assets: #{$!}"
        end
        redirect_to admin_plugin_path('datajam-datacard')
      end
    end
  end
end
