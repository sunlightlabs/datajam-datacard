require 'faraday'
require 'json'

module Faraday
  # Public: Faraday's middleware which decodes JSON encoded 
  # response body into ruby object.
  class Response::JsonDecoded < Response::Middleware
    def call(env)
      @app.call(env).on_complete do |finished_env|
        finished_env[:data] = parse_json(finished_env[:body])
      end
    end
    
    private

    def parse_json(body)
      JSON.parse(body)
    rescue JSON::ParserError
      []
    end
  end
end

Faraday::Response.register_middleware :json_decoded => Faraday::Response::JsonDecoded
