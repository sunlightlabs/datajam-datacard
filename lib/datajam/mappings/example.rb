class ExampleMapping < Datajam::Datacard::APIMapping::Base
  name        "Example mapping"
  version     "1.0"
  authors     "Chris Kowalik"
  email       "chris@cuboxlabs.com"
  homepage    "http://cuboxlabs.com/"
  summary     "An example API"
  description "..."
  base_uri    "http://127.0.0.1/example/"

  setting :api_key, "API Key", :type => :text

  get "/items" do
    param :filter, "Filter", :type => :text
    param :group, "Select group" do
      type :select, :options => ['Foo', 'Bar', 'Baz']
    end
  end

  get "/users" do
    param :filter, "Filter", :type => :text
  end
end
