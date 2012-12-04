require File.expand_path('../../spec_helper', __FILE__)
require 'ruby-debug'

describe CsvData do
  include DataCardExampleHelperMethods

  it "Deals with multiple data files of the same name correctly" do
    csv_with_file = from_csv
    File.open('./datacard_spec.csv', 'wb') do |f|
      f << "Title,Text\n"
      f << "Test,Things!"
    end
    csv_with_file[:data_set_attributes][:sourced_attributes] = from_csv[:data_set_attributes][:sourced_attributes].merge(data_file: Rack::Multipart::UploadedFile.new('./datacard_spec.csv', 'text/csv'))
    card1 = DataCard.create!(csv_with_file)

    File.open('./datacard_spec.csv', 'wb') do |f|
      f << "Title,Text\n"
      f << "Tests,Thingses!"
    end
    csv_with_file[:data_set_attributes][:sourced_attributes] = from_csv[:data_set_attributes][:sourced_attributes].merge(data_file: Rack::Multipart::UploadedFile.new('./datacard_spec.csv', 'text/csv'))
    card2 = DataCard.create!(csv_with_file)

    File.delete('./datacard_spec.csv')

    card1.html.should_not include "Thingses"
    card2.html.should include "Thingses"
    card1.data_set.sourced.data_file.present?.should be_false
    card2.data_set.sourced.data_file.present?.should be_false
  end
end