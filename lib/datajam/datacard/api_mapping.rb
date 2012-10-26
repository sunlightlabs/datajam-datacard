require 'datajam/datacard/mappings'

module Datajam
  module Datacard
    module APIMapping
      require 'datajam/datacard/api_mapping/errors'
      require 'datajam/datacard/api_mapping/definition'
      require 'datajam/datacard/api_mapping/input_field'
      require 'datajam/datacard/api_mapping/output_field'
      require 'datajam/datacard/api_mapping/metadata_attributes'
      require 'datajam/datacard/api_mapping/settings'
      require 'datajam/datacard/api_mapping/response_definition'
      require 'datajam/datacard/api_mapping/endpoint_definition'
      require 'datajam/datacard/api_mapping/endpoints'
      require 'datajam/datacard/api_mapping/request'
      require 'datajam/datacard/api_mapping/defaults'

      # Base class for API mappings, which provides full stack DSL
      # to describe configuration and endpoints.
      #
      # Check `lib/datajam/datacard/mappings/*.rb` files to see examples.
      class Base
        class << self
          alias_method :id, :name
        end

        extend MetadataAttributes
        extend Settings
        extend Endpoints
        extend Request
        extend Defaults

        # Callback executed when new mapping inherits after Base.
        # It registers given component in mappings list.
        #
        # component - A mapping to be registered.
        #
        def self.inherited(component)
          Datajam::Datacard.mappings << component
        end
      end
    end
  end
end
