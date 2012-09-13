module Datajam
  module Datacard
    module UninstallJob
      def self.perform
        # Delete all installed assets from GridFS
        fs = Mongo::GridFileSystem.new(Mongoid.database)
        Dir.glob("#{Datajam::Datacard::Engine.root}/public/**/*.*") do |filepath|
          filename = filepath.gsub("#{Datajam::Datacard::Engine.root}/public/", '')
          fs.delete(filename)
        end
        # Remove DataCardArea instances from events
        Event.all.each do |event|
          event.content_areas.where(:area_type => 'data_card_area').destroy_all
          # kill any legacy cards if they're there
          event.content_areas.where(:area_type => 'datacard_area').destroy_all
        end
        # Remove settings
        Setting.where(:namespace => 'datajam-datacard').destroy_all
        Datajam::Settings.flush('datajam-datacard')
      end
    end
  end
end
