module Datajam
  module Datacard
    module APIMapping
      # Public: Raised when requested endpoint is not defined.
      class EndpointNotFoundError < StandardError
        def initialize(endpoint_name)
          super "Endpoint #{endpoint_name} is not defined"
        end
      end
    end
  end
end
