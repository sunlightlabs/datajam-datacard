module Datajam
  module Datacard
    module APIMapping
      # Internal: Representation of a single endpoint's mapping definition.
      class EndpointDefinition < Definition
        attr_magic :uri
        attr_magic :http_verb

        # Public: Returns all defined params.
        def params
          @params ||= {}
        end

        # Public: Defines new param mapping.
        #
        # name    - A String name of the param.
        # options - An optional Hash with param information.
        # block   - An optional block that can be used to customize param's
        #           behavior or attributes.
        #
        # Examples
        #
        #   param :amount, :label => "Contribution count", :placeholder => 500
        #   param :cycle do
        #     label "Election cycle"
        #     help_text "The year of the election cycle to get results for"
        #     type :select
        #     options (1990..Time.now.year).step(2).to_a
        #   end
        #
        # Returns new param definition.
        def param(name, options = {}, &block)
          params[name] = InputField.new(name, options, &block)
        end

        # Public: Gets or Defines a response mapping for this endpoint.
        #
        # block - An optional block that will be eval'd into the endpoint definition
        #         to define fields for this endpoint's response.
        #
        # Example
        #
        #   response do
        #     field :foo
        #     ...
        #   end
        #
        # Returns endpoint's response definition.
        def response(&block)
          @response ||= ResponseDefinition.new(&block)
        end
      end
    end
  end
end
