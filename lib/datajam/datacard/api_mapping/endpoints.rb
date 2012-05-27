module Datajam
  module Datacard
    module APIMapping
      # Internal: Module provides mappings' endpoints definitions.
      module Endpoints
        # Public: Returns all defined endpoints.
        def endpoints
          @endpoints ||= {}
        end
        
        # Public: Defines new endpoint mapping.
        #
        # name    - A String name of the endpoint.
        # title   - An optional descriptive title of the endpoint.
        # options - An optional Hash with endpoint information.
        # block   - An optional block that can be used to customize endpoint
        #           behavior or attributes.
        #
        # Examples
        #
        #   endpoint :contributions, "Campaign contributions" do
        #     uri "contributions.json"
        #
        #     param :amount, "Contribution count", :placeholder => 500
        #     param :organization_ft, "Organization"
        #     # ...
        #   end
        #
        # Returns new endpoint definition.
        def endpoint(name, title = nil, options = {}, &block)
          endpoints[name.to_sym] = EndpointEntry.new(name, title, options, &block)
        end

        # Shorthands for defining endpoints with access via various HTTP
        # methods. There's a method defined for each HTTP verb.
        
        %w{get post put delete patch}.each do |verb|
          class_eval(<<-EVAL)
            def #{verb}(name, title = nil, options = {}, &block)
              options.merge!({ :http_verb => "#{verb.upcase}" })
              endpoint(name, title, options, &block)
            end
          EVAL
        end
      end
    end
  end
end
