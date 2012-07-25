module Datajam
  module Datacard
    module InstallJob
      def self.perform
        # install assets
        Datajam::Datacard::RefreshAssetsJob.perform
        # install settings
        Datajam::Datacard::Engine.load_seed
      end
    end
  end
end
