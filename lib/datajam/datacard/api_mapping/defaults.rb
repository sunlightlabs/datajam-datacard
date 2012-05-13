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
        #   def http_setup(conn)
        #     conn.use Faraday::Request::UrlEncoded
        #     conn.use Faraday::Response::DecodeJSON
        #
        #     conn.request  :url_encoded
        #     conn.response :decode_json
        #   end
        #
        def http_setup(conn)
          # ...
        end
      end
    end
  end
end
