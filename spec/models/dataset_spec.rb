require File.expand_path('../../spec_helper', __FILE__)

describe Dataset do
  describe "#data" do
    let(:dataset) do
      Dataset.create(:name => "test")
    end

    it "contains polymorphic relation to dataset source" do
      dataset.data = CsvData.create(:source => "foo,bar\nbaz,bla\n")
      dataset.save.should be
      dataset.data.should be_kind_of(CsvData)
      dataset.data.source.should == "foo,bar\nbaz,bla\n"
    end
  end
end
