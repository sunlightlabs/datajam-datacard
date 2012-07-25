namespace :datacard do
  desc "Install Datacard"
  task :install => :environment do
    Datajam::Datacard::InstallJob.perform
  end

  desc "Uninstall Datacard"
  task :uninstall => :environment do
    Datajam::Datacard::UninstallJob.perform
  end

  desc "Refresh static assets"
  task :refresh_assets => :environment do
    Datajam::Datacard::RefreshAssetsJob.perform
  end
end