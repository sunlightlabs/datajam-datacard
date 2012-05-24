class SmarterAPIMapping < Datajam::Datacard::APIMapping::Base
  name        "Smarter"
  version     "1.0"
  authors     "Marty MacFly"
  email       "marty@macfly.com"
  homepage    "http://marty.macfly.com/smarter"
  summary     "A dummy API"
  description "..."
  base_uri    "http://marty.macfly.com/api/2.0"

  get :hello, "Greetings" do
    uri "/hello.json"
    
    param :greetings, "Greetings to say"
    param :author, "Author"
  end

  protected

  def http_setup(conn)
    conn.use Faraday::Request::UrlEncoded
    conn.request :url_encoded
  end
end
