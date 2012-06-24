module Datajam
  module Datacard
    module APIMapping
      # Internal: Module provides settings definitions for the mapping.
      module Settings
        # Public: Returns all defined settings information.
        def settings
          @settings ||= {}
        end
        
        # Public: Defines new setting.
        #
        # name    - A String name of the setting.
        # title   - An optional descriptive title of the setting.
        # options - An optional Hash setting information.
        # block   - An optional block that can be used to customize setting
        #           behavior or attributes.
        #
        # Examples
        #
        #   setting :api_key, "API Key", :type => :text
        #
        #   setting :api_key do
        #     name "API Key"
        #     type :text
        #   end
        #
        # Returns new setting field definition.
        def setting(name, title = nil, options = {}, &block)
          settings[name] = Field.new(name, title, options, &block)
        end

        # Public: Returns settings persisted in the system.
        def persisted_settings
          @persisted_settings ||= load_settings or create_empty_settings
        end

        private

        def load_settings
          MappingSettings.where(mapping_id: self.id).first
        end

        def create_empty_settings
          MappingSettings.create(mapping_id: self.id)
        end
      end
    end
  end
end
