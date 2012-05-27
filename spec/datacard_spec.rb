require File.expand_path('../spec_helper', __FILE__)

describe Datajam::Datacard do
  describe ".mappings" do
    it "returns list of registered mappings" do
      subject.mappings.should include(DummyAPIMapping)
    end
  end
end
