require 'faraday/response/json_decoded'
require 'faraday/response/csv_translated'

class InfluenceExplorerMapping < Datajam::Datacard::APIMapping::Base
  name        "Influence Explorer"
  version     "1.0"
  authors     "Dan Drinkard"
  email       "dan.drinkard@gmail.com"
  homepage    "http://datajam.org/datacards/influence-explorer"
  summary     "An API mapping to add Influence Explorer as a data source for card visualizations"
  description "..."
  base_uri    "http://transparencydata.com/api/1.0/"

  setting :apikey, "API Key", :type => :string

  get :contributions, "Campaign contributions" do
    uri "/contributions.json"
    #paginate "rpp=100&page=%d"
    help_text "Information about campaign contributions for or against a particular candidate for office"

    param :amount, "Contribution amount", :placeholder => 500 #, :validate => :number_with_comparison_operators
    param :contributor_ft, "Contributor"
    param :contributor_state, "Contributor state", :placeholder => "AK" #, :validate => {:length => 2}

    param :cycle, "Election cycle" do
      help_text "The year of the election cycle to get results for"
      type :select, :options => (1990..Time.now.year).step(2).to_a
      prompt "Select cycle"
    end

    param :date, "Contribution date" do
      help_text = "Date of the contribution in ISO date format"
      #validate :date_with_comparison_operators
    end

    param :for_against, "For/against", :type => :select, :options => {:for => "In support of", :against => "Against"}
    param :organization_ft, "Organization"
    param :recipient_ft, "Recipient"

    param :seat, "Seat" do
      help_text "Type of office being sought"
      type :select, :options => {
        "federal:senate" => "US Senate",
        "federal:house" => "US House of Representatives",
        "federal:president" => "US President",
        "state:upper" => "Upper chamber of state legislature",
        "state:lower" => "Lower chamber of state legislature",
        "state:governor" => "State governor"
      }
      prompt "Select type of the office"
    end

    param :transaction_namespace, "Transaction namespace" do
      help_text "Filters on federal or state contributions"
      type :select, :options => {
        "urn:fec:transaction" => "Federal contributions",
        "urn:nimsp:transaction" => "State contributions"
      }
      prompt "Select type of the contribution"
    end
  end

  def self.http_setup(conn)
    conn.request  :url_encoded
    conn.response :csv_translated
    conn.response :json_decoded
  end
end
