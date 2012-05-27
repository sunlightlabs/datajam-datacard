require File.expand_path('../spec_helper', __FILE__)

describe Datajam::Datacard::Mappings do
  subject do
    Datajam::Datacard.mappings
  end

  describe ".find_by_klass" do
    context "when searched klass is registered" do
      it "returns it" do
        subject.find_by_klass("DummyAPIMapping").should == DummyAPIMapping
      end
    end

    context "when searched klass is not registered" do
      it "returns nil" do
        subject.find_by_klass("NotExists").should_not be
      end
    end
  end
end
