require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../fixtures/dummy_api_mapping', __FILE__)

describe Datajam::Datacard::APIMapping do
  subject do
    DummyAPIMapping
  end

  describe ".endpoint" do
    it "defines new endpoint with field information" do
      subject.endpoint :marty, "Marty Macfly"
      subject.endpoints.should have_key(:marty)
      subject.endpoints[:marty].tap do |marty|
        marty.name.should == :marty
        marty.title.should == "Marty Macfly"
      end
    end

    context "when block given" do
      it "executes it within field instance" do
        subject.endpoint :doc do
          title     "Emmet Brown"
          help_text "Doctor invented a time machine"
        end
        subject.endpoints.should have_key(:doc)
        subject.endpoints[:doc].tap do |doc|
          doc.name.should == :doc
          doc.title.should == "Emmet Brown"
          doc.help_text.should == "Doctor invented a time machine"
        end
      end
    end
  end

  %w{get post put delete patch}.each do |verb|
    describe ".#{verb}" do
      it "registers an endpoint accessed via #{verb.upcase} http method" do
        subject.send(verb.to_sym, verb.to_sym, "Test")
        subject.endpoints[verb.to_sym].http_verb.should == verb.upcase
      end
    end
  end

  describe "endpoint entries with params" do
    it "should be registered correctly" do
      subject.get :biff, "Biff Tannen" do
        param :greeting, "Greeting", :type => :text, :placeholder => "Hello Biff!"
        param :another do
          title "Another one"
          type  :select, :options => (1..5).to_a
        end
      end
      subject.endpoints[:biff].tap do |biff|
        biff.params.should have_key(:greeting)
        biff.params[:greeting].tap do |greeting|
          greeting.name.should == :greeting
          greeting.title.should == "Greeting"
          greeting.type.should == :text
          greeting.placeholder.should == "Hello Biff!"
        end
        biff.params.should have_key(:another)
        biff.params[:another].tap do |another|
          another.type.should == :select
          another.options.should == (1..5).to_a
        end
      end
    end
  end
end
