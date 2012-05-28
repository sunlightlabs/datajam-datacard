require 'faraday'
require 'uri'

module Datajam
  module Datacard
    module APIMapping
      # Internal: Module defines stuff used to perform requests to the
      # endpoints.
      module Request
        # Public: Performs request to the endpoint, sending given params.
        #
        # endpoint_name - A String or Symbol name of the endpoint.
        # param         - A Hash with params to be sent in the request.
        #
        # Returns fetched response.
        def request(endpoint_name, params = {})
          endpoint = endpoints[endpoint_name] 
          raise EndpointNotFoundError.new(endpoint_name) unless endpoint

          conn, verb = new_conn(endpoint), endpoint.http_verb.downcase
          conn.send(verb, File.join(parsed_base_uri.path, endpoint.uri), params)
        end

        protected

        # Internal: Creates new connection set up for the mapping and
        # specified endpoint.
        #
        # endpoint - An endpoint for which this conneciton will be configured.
        #
        # Returns configured connection.
        def new_conn(endpoint)
          Faraday.new(:url => parsed_base_uri.to_s) do |conn|
            conn.use Faraday::Adapter::NetHttp
            conn.adapter :net_http
            http_setup(conn)
          end
        end

        def parsed_base_uri
          @parsed_base_uri ||= URI.parse(base_uri)
        end
      end
    end
  end
end
