module Datajam
  module Datacard
    module RefreshAssetsJob
      def self.perform
        # Copy files to GridFS
        fs = Mongo::GridFileSystem.new(Mongoid.database)
        Dir.glob("#{Datajam::Datacard::Engine.root}/public/**/*.*") do |filepath|
          filename = filepath.gsub("#{Datajam::Datacard::Engine.root}/public/", '')
          fs.open(filename, 'w', :delete_old => true) do |f|
            f.write(File.open(filepath))
          end
        end
      end
    end
  end
end
