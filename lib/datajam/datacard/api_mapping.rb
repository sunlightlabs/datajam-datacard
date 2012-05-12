module Datajam
  module Datacard
    module APIMapping
      require 'datajam/datacard/api_mapping/metadata_attributes'
      
      def self.included(base)
        base.send :extend, MetadataAttributes
      end
    end
  end
end
