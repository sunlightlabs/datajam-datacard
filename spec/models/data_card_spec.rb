require File.expand_path('../../spec_helper', __FILE__)

describe DataCard do
  include DataCardExampleHelperMethods

  it "can be created from html" do
    card = DataCard.create!(from_html)
    card.html.should include "hello, world!"
  end

  it "can be created from csv" do
    card = DataCard.create!(from_csv)
    card.html.should include "<td>Thing 1</td>"
  end

  it "includes all fields when created from csv without a series string" do
    data = from_csv
    data.delete(:series_string)
    card = DataCard.create!(data)
    card.html.should include "<th>Title</th>"
    card.html.should include "<th>Text</th>"
    card.html.should include "<th>Number</th>"
  end

  it "re-renders when edited" do
    card = DataCard.create!(from_csv)
    card.html.should include "<td>Thing 1</td>"
    new_attrs = from_csv
    new_attrs[:data_set_attributes][:sourced_attributes][:data].gsub!("Thing", "Foo")
    card.update_attributes(new_attrs)
    card.html.should include "<td>Foo 1</td>"
  end

  it "throws an error when given invalid csv" do
    card_params = from_csv
    card_params[:data_set_attributes][:sourced_attributes][:data] = "\"A\", \"b\" \n1, 2"
    card = DataCard.create(card_params)
    card.persisted?.should be_false
    card.html.should be_blank
    card.data_set.sourced.errors.full_messages.to_sentence.should include("Illegal quoting")
  end

  it "can be created from API mapping params" do
    VCR.use_cassette "mapping_card" do
      card = DataCard.create!(from_mapping)
      card.html.should include "cardData = [{"
    end
  end

  it "caches tags for searching" do
    card = DataCard.create!(from_html)
    card.cached_tag_string.should_not be_blank
    card.cached_tag_string.should == card.tag_string
  end

  it "indicates its display type and provenance" do
    VCR.use_cassette "mapping_card" do
      card1 = DataCard.create!(from_html)
      card2 = DataCard.create!(from_csv)
      card3 = DataCard.create!(from_mapping)
      card1.is_html?.should be_true
      card2.is_table?.should be_true
      card2.from_csv?.should be_true
      card2.from_mapping?.should be_false
      card3.is_graphy?.should be_true
      card3.from_mapping?.should be_true
    end
  end

  it "inherits its source info from an available API Mapping" do
    VCR.use_cassette "mapping_card" do
      card = DataCard.create!(from_mapping)
      card.source.should == SmarterAPIMapping.name
      card.source.should_not be_blank
    end
  end

  it "indicates when other cards are based on its data set" do
    card1 = DataCard.create!(from_csv)
    card1.has_siblings?.should be_false
    card2_params = from_csv
    card2_params.delete("data_set_attributes")
    card2_params["data_set_id"] = card1.data_set.id.to_s
    card2 = DataCard.create!(card2_params)
    card2.has_siblings?.should be_true
    card1.has_siblings?.should be_true
  end

  it "returns its sibling cards correctly" do
    card1 = DataCard.create!(from_csv)
    card2_params = from_csv
    card2_params.delete("data_set_attributes")
    card2_params["data_set_id"] = card1.data_set.id.to_s
    card2 = DataCard.create!(card2_params)
    card2.siblings.should == [card1]
  end

  it "can set series fields from a comma-delimited string" do
    card = DataCard.create!(from_csv)
    card.series.should === ["Title", "Text"]
  end

  it "can convert series fields to a comma-delimited string" do
    card = DataCard.create!(from_csv)
    card.series_string.should == "Title, Text"
  end

  it "returns prepared data in the specified format" do
    card = DataCard.create!(from_csv)
    card.prepared_data(:csv)[0].should == ["Title", "Text"]
    card.prepared_data(:csv)[1].should == ["Thing 1", "Thing 1 is a thing"]
    card.prepared_data(:json)[0].should == {"Title" => "Thing 1", "Text" => "Thing 1 is a thing"}
  end

  it "gets garbage collected when its data is deleted" do
    card = DataCard.create!(from_csv)
    card.persisted?.should be_true
    card.data_set.sourced.destroy
    card.persisted?.should be_false
  end
end
