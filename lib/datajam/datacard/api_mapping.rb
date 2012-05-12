module Datajam
  module Datacard
    module APIMapping
      require 'datajam/datacard/api_mapping/field'
      require 'datajam/datacard/api_mapping/metadata_attributes'
      require 'datajam/datacard/api_mapping/settings'
      
      def self.included(base)
        base.send :extend, MetadataAttributes
        base.send :extend, Settings
      end
    end
  end
end
