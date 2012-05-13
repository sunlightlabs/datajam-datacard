module Datajam
  module Datacard
    module APIMapping
      # Internal: Representation of a single endpoint's mapping definition.
      class EndpointEntry < Definition
        attr_magic :uri
        attr_magic :http_verb
        
        # Public: Returns all defined params.
        def params
          @params ||= {}
        end
        
        # Public: Defines new param mapping.
        #
        # name    - A String name of the param.
        # title   - An optional descriptive title of the param.
        # options - An optional Hash with param information.
        # block   - An optional block that can be used to customize param's
        #           behavior or attributes.
        #
        # Returns new param definition.
        def param(name, title = nil, options = {}, &block)
          params[name] = Field.new(name, title, options, &block)
        end
      end
    end
  end
end
