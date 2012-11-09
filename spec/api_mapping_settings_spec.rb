require File.expand_path('../spec_helper', __FILE__)

describe Datajam::Datacard::APIMapping do
  subject do
    DummyAPIMapping
  end

  describe ".setting" do
    it "defines new setting with field information" do
      subject.setting :api_key, label: "API Key", :type => :text
      subject.settings.should have_key(:api_key)
      subject.settings[:api_key].tap do |api_key|
        api_key.label.should == "API Key"
        api_key.type.should == :text
      end
    end

    context "when block given" do
      it "executes it within field instance" do
        subject.setting :another_key do
          label "Some key"
          type  :text
        end
        subject.settings.should have_key(:another_key)
        subject.settings[:another_key].tap do |another|
          another.label.should == "Some key"
          another.type.should == :text
        end
      end
    end
  end

  describe "persistend_settings" do
    it "returns object for settings stored in the database" do
      subject.persisted_settings.should be_kind_of(MappingSettings)
    end
  end
end
