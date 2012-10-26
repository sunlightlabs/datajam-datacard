require 'json'
require 'faraday/response/json_decoded'
require 'faraday/response/csv_translated'

class InfluenceExplorerMapping < Datajam::Datacard::APIMapping::Base
  name        "Influence Explorer"
  version     "1.0"
  authors     "Dan Drinkard"
  email       "dan.drinkard@gmail.com"
  homepage    "http://datajam.org/datacards/influence-explorer"
  summary     "An API mapping to add Influence Explorer as a data source for card visualizations"
  description "Note: The Influence Explorer API does not support pagination. Filter queries based on a min or max amount and sort from there."
  base_uri    "http://transparencydata.com/api/1.0/"
  data_type   :json

  setting :apikey, label: "API Key", type: :string

  get :contributions, "Campaign contributions" do
    uri "/contributions.json"
    # paginate "rpp=1000&page=%d"
    help_text "Information about campaign contributions for or against a particular candidate for office"

    param :amount, label: "Contribution amount", placeholder: 500 #, validate: :number_with_comparison_operators
    param :contributor_ft, label: "Contributor"
    param :contributor_state, label: "Contributor state", placeholder: "AK" #, validate: {length: 2}
    param :cycle, label: "Election cycle" do
      help_text "The year of the election cycle to get results for"
      type :select, options: (1990..Time.now.year).step(2).to_a
      prompt ""
    end
    param :date, label: "Contribution date" do
      help_text "Date of the contribution in ISO date format"
      #validate :date_with_comparison_operators
    end
    param :for_against, label: "For/against", type: :select, options: {for: "In support of", against: "Against"}, prompt: ""
    param :organization_ft, label: "Organization"
    param :recipient_ft, label: "Recipient"
    param :seat, label: "Seat" do
      help_text "Type of office being sought"
      type :select, options: {
        :"federal:senate" => "US Senate",
        :"federal:house" => "US House of Representatives",
        :"federal:president" => "US President",
        :"state:upper" => "Upper chamber of state legislature",
        :"state:lower" => "Lower chamber of state legislature",
        :"state:governor" => "State governor"
      }
      prompt ""
    end
    param :transaction_namespace, label: "Transaction namespace" do
      help_text "Filters on federal or state contributions"
      type :select, options: {
        :"urn:fec:transaction" => "Federal contributions",
        :"urn:nimsp:transaction" => "State contributions"
      }
      prompt ""
    end

    response do
      field :seat do
        label "Seat Sought"
        value_reader do |val|
          {
            "federal:senate" => "US Senate",
            "federal:house" => "US House of Representatives",
            "federal:president" => "US President",
            "state:upper" => "State Legislature - Upper Chamber",
            "state:lower" => "State Legislature - Lower Chamber",
            "state:governor" => "Governor"
            }[val]
        end
      end
      field :seat_held do
        value_reader do |val|
          {
            "federal:senate" => "US Senate",
            "federal:house" => "US House of Representatives",
            "federal:president" => "US President",
            "state:upper" => "State Legislature - Upper Chamber",
            "state:lower" => "State Legislature - Lower Chamber",
            "state:governor" => "Governor"
            }[val]
        end
      end
      field :recipient_party do
        value_reader do |val|
          {"D" => "Democrat", "R" => "Republican", "I" => "Independent"}[val] || "Other"
        end
      end
      field :recipient_type do
        value_reader do |val|
          {"C" => "Committee", "O" => "Organization", "P" => "Politician"}[val]
        end
      end
      field :seat_status do
        value_reader do |val|
          {"I" => "Incumbent", "O" => "Open"}[val]
        end
      end
      field :recipient_state
      field :contributor_state
      field :is_amendment do
        value_reader do |val|
          val ? "Yes" : "No"
        end
      end
      field :district
      field :organization_name
      field :contributor_occupation
      field :contributor_city do
        value_reader do |val|
          val.titleize
        end
      end
      field :recipient_state_held
      field :district_held
      field :recipient_name
      field :contributor_zipcode
      field :date
      field :committee_name
      field :candidacy_status do
        value_reader do |val|
          val ? "Yes" : "No"
        end
      end
      field :cycle, label: "Election Cycle"
      field :contributor_name
      field :contributor_type do
        value_reader do |val|
          {"I" => "Individual", "C" => "PAC"}[val]
        end
      end
      field :contributor_employer
      field :amount do
        value_reader do |val|
          val.to_f
        end
      end
      field :committee_party do
        value_reader do |val|
          {"D" => "Democrat", "R" => "Republican", "I" => "Independent"}[val] || "Other"
        end
      end
    end
  end

  def self.process_response(resp)
    resp.env[:body]
  end
end
