class ExampleMapping < Datajam::Datacard::APIMapping::Base
  name        "Example mapping"
  version     "1.0"
  authors     "Chris Kowalik"
  email       "chris@cuboxlabs.com"
  homepage    "http://cuboxlabs.com/"
  summary     "An example API"
  description "..."
  base_uri    "http://127.0.0.1/example/"

  setting :api_key, "API Key", :type => :string

  get :items, "Example items" do
    uri "/items.json"

    param :filter, "Filter", :type => :string
    param :group, "Select group" do
      type   :select, :options => ['Foo', 'Bar', 'Baz']
      prompt 'Select something...'
    end
  end

  get :users, "Examle users" do
    uri "/users.json"

    param :filter, "Filter", :type => :string
  end
end
