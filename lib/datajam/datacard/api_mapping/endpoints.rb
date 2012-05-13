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
          endpoints[name] = EndpointEntry.new(name, title, options, &block)
        end

        # Shorthands for defining endpoints with access via various HTTP
        # methods. There's a method defined for each HTTP verb.
        #
        # Btw... Yes, I know we can define it by looping through list of
        # verbs and calling #class_eval or less likely #define_method
        # but it magically sucks. Magic limit already has been reached
        # for this project.

        def get(name, title = nil, options = {}, &block)
          endpoint(name, title, options.merge({:http_verb => "GET"}), &block)
        end

        def post(name, title = nil, options = {}, &block)
          endpoint(name, title, options.merge({:http_verb => "POST"}), &block)
        end

        def put(name, title = nil, options = {}, &block)
          endpoint(name, title, options.merge({:http_verb => "PUT"}), &block)
        end

        def delete(name, title = nil, options = {}, &block)
          endpoint(name, title, options.merge({:http_verb => "DELETE"}), &block)
        end

        def patch(name, title = nil, options = {}, &block)
          endpoint(name, title, options.merge({:http_verb => "PATCH"}), &block)
        end
      end
    end
  end
end
