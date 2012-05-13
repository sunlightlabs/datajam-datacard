module Datajam
  module Datacard
    module APIMapping
      require 'datajam/datacard/api_mapping/definition'
      require 'datajam/datacard/api_mapping/field'
      require 'datajam/datacard/api_mapping/metadata_attributes'
      require 'datajam/datacard/api_mapping/settings'
      require 'datajam/datacard/api_mapping/endpoint_entry'
      require 'datajam/datacard/api_mapping/endpoints'
      
      def self.included(base)
        base.send :extend, MetadataAttributes
        base.send :extend, Settings
        base.send :extend, Endpoints
      end
    end
  end
end
