require File.expand_path('../../spec_helper', __FILE__)

describe MappingResponse do
  describe "#data= and #data" do
    it "stores and loads marshaled data" do
      response = MappingResponse.new(:data => [1,2])
      response.data.should =~ [1,2]
    end
  end
end
