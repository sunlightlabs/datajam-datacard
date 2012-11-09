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

  describe ".push" do
    context "when mapping is not registered" do
      it "adds the mapping" do
        subject.find_by_klass("SmarterApiMapping").should_not be
        class SmarterApiMapping
          def self.id
            "SmarterApiMapping"
          end
        end
        subject.push SmarterAPIMapping
        subject.find_by_klass("SmarterAPIMapping").should == SmarterAPIMapping
      end
    end
    context "when mapping is already registered" do
      it "doesn't add the mapping" do
        subject.select{|m| m == DummyAPIMapping}.length.should == 1
        subject.push DummyAPIMapping
        subject.select{|m| m == DummyAPIMapping}.length.should == 1
      end
    end
  end
end
