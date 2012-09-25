require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/smarter_api_mapping', __FILE__)

describe MappingRequest do
  let(:mapping) do
    SmarterAPIMapping
  end
  
  let(:endpoint) do
    mapping.endpoints[:hello]
  end
  
  let(:params) do
    { :author => "Foo", :greetings => "Bar" }
  end

  let(:request) do
    MappingRequest.prepare(mapping, endpoint, params)
  end

  describe ".prepare" do
    it "returns instance of mapping request prepare for mapping, endpoint and params" do
      request.mapping_id.should == mapping.id
      request.params.should == params
      request.endpoint_name.to_s.should == endpoint.name.to_s
      request.mapping.should == mapping
    end
  end

  describe "#mapping" do
    before do
      request.save
    end
    
    it "finds appropriate mapping by it's id" do
      MappingRequest.find(request.id).mapping.should == mapping
    end
  end

  describe "#perform_request" do
    let(:data) do
      request.perform_request 
    end
  
    it "returns data got from endpoint" do
      pending "Fakeweb doesn't work, find another way to test it"
      #expect { data }.to_not raise_error(MappingRequest::Error)
      #data.should have(1).item
      #data.first.should == {"foo" => "bar"}
    end

    it "raises MappingRequest::Error if something went wrong" do
      pending "Fakeweb doesn't work, find another way to test it"
    end
  end

  describe "#perform!" do
    it "performs request and creates new mapping data entry" do
      request.expects(:perform_request).returns([{"foo" => "bar"}])
      request.perform!
      request.should be_persisted
      request.datum.should have(1).item
      request.datum.first.source.first["foo"].should == "bar"
    end
  end
  
  describe "#perform_for!" do
    it "performs request and updates given mapping data" do
      data = request.datum.build(:source => [{"foo" => "bar"}])
      request.save and data.save
      request.expects(:perform_request).returns([{"bar" => "baz"}])
      request.perform_for!(data)
      data.reload.source.first.should_not have_key("foo")
      data.source.first["bar"].should == "baz"
    end
  end
end
