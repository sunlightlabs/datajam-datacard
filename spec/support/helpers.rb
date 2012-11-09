module DataCardExampleHelperMethods
  def from_html
    {
      title: "from html card",
      source: "html text",
      html: "<h2>hello, world!</h2>",
      tag_string: "global",
      display_type: "html",
    }
  end

  def from_csv
    {
      title: "from csv card",
      source: "csv data",
      tag_string: "global",
      display_type: "table",
      series_string: "Title, Text",
      limit: 3,
      data_set_attributes: {
        sourced_type: "CsvData",
        sourced_attributes: {
          data: "Title,Text,Number\nThing 1,Thing 1 is a thing,5\nThing 2,Thing 2 is a totally different thing,124",
          source: "A website"
        }
      }
    }
  end

  def from_mapping
    {
      title: "from mapping card",
      source: nil,
      tag_string: "global",
      display_type: "column_chart",
      group_by: "month",
      series_string: "Title, Text",
      data_set_attributes: {
        sourced_type: "MappingData",
        sourced_attributes: {
          mapping_id: "SmarterAPIMapping",
          endpoint_name: "word_over_time",
          params: {
            phrase: "capitol",
            apikey: "c711d58a1c634f0aa366c21ddc4de6c7",
            start_date: "2012-01-01",
            end_date: "2012-08-01",
            granularity: "month"
          }
        }
      }
    }
  end
end

class DummyAPIMapping < Datajam::Datacard::APIMapping::Base
  name        "Dummy"
  version     "1.0"
  authors     "Marty MacFly"
  email       "marty@macfly.com"
  homepage    "http://marty.macfly.com/dummy"
  summary     "A dummy API"
  description "..."
  base_uri    "http://marty.macfly.com/api/1.0"
  data_type   :json
end

class DummyMagicAttrs
  extend Datajam::Datacard::MagicAttrs
end

class SmarterAPIMapping < Datajam::Datacard::APIMapping::Base
  name        "Smarter"
  version     "1.0"
  authors     "Marty MacFly"
  email       "marty@macfly.com"
  homepage    "http://marty.macfly.com/smarter"
  summary     "A dummy API"
  description "..."
  base_uri    "http://capitolwords.org/api"
  data_type   :json

  get :word_over_time, "Word Over Time" do
    uri "/dates.json"

    param :phrase
    param :start_date
    param :end_date
    param :granularity
    param :apikey
    response do
      field :count
      field :month
    end
  end

  protected

  def http_setup(conn)
    conn.use Faraday::Request::UrlEncoded
    conn.request :url_encoded
  end
end
