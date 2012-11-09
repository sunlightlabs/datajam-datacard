module Datajam
  module Datacard
    module APIMapping
      # Public: Raised when requested endpoint is not defined.
      class EndpointNotFoundError < StandardError
        def initialize(endpoint_name)
          super "Endpoint #{endpoint_name} is not defined"
        end
      end

      class InvalidRequestError < StandardError
        def initialize(fields)
          super "The following field values were not found or invalid: #{fields.join(', ')}"
        end
      end
    end
  end
end
