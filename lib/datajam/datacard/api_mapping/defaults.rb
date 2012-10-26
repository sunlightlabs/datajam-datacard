module Datajam
  module Datacard
    module APIMapping
      # Internal: Module defines few default methods which should be
      # overriden by the user.
      module Defaults
        # Public: Allows user to add custom setup to Faraday's HTTP
        # connection builder.
        #
        # conn - A Faraday's connection builder instance to be set up.
        #
        # Examples
        #
        #   def self.http_setup(conn)
        #     conn.use Faraday::Request::UrlEncoded
        #     conn.use Faraday::Response::DecodeJSON
        #
        #     conn.request  :url_encoded
        #     conn.response :decode_json
        #   end
        #
        def http_setup(conn)
          conn.request  :url_encoded
          conn.response :csv_translated, content_type: /\bcsv$/
          conn.response :json, content_type: /\bjson$/
        end

        # Public: Processes a Mapping request, formatting the response data
        #
        # endpoint_name - A String or Symbol name of the endpoint.
        # param         - A Hash with params to be sent in the request.
        #
        # Returns fetched response.
        def process_response(endpoint_name, response)
          endpoint = endpoints[endpoint_name]
          raise EndpointNotFoundError.new(endpoint_name) unless endpoint
          # Do stuff...
        end
      end
    end
  end
end
