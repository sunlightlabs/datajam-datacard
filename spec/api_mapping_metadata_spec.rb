require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../fixtures/dummy_api_mapping', __FILE__)

describe Datajam::Datacard::APIMapping do
  subject do
    DummyAPIMapping
  end

  describe "after include" do
    it "provides set of mapping metadata attributes" do
      subject.should respond_to(:name)
      subject.should respond_to(:version)
      subject.should respond_to(:authors)
      subject.should respond_to(:email)
      subject.should respond_to(:homepage)
      subject.should respond_to(:summary)
      subject.should respond_to(:description)
      subject.should respond_to(:base_uri)
    end
  end

  describe "mapping metadata" do
    it "should be properly set within the class" do
      subject.name.should == "Dummy"
      subject.version.should == "1.0"
      subject.authors.should == "Marty MacFly"
      # and so on...
    end
  end
end
