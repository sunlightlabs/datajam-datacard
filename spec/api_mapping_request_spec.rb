require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../fixtures/dummy_api_mapping', __FILE__)
require File.expand_path('../fixtures/smarter_api_mapping', __FILE__)

describe Datajam::Datacard::APIMapping do
  describe ".request" do
    subject do
      DummyAPIMapping
    end

    context "when there's no such endpoint defined" do
      it "raises appropriate error" do
        expect {
          subject.request(:no_such_endpoint, {})
        }.to raise_error(Datajam::Datacard::APIMapping::EndpointNotFoundError)
      end
    end

    context "when endpoint is defined" do
      subject do
        SmarterAPIMapping
      end

      it "performs proper request" do
        params = { :author => 'Marty', :greetings => 'Sup Doc!' }

        Faraday::Connection.any_instance.expects(:get)
          .with('/api/2.0/hello.json', params)
          .returns('ok')

        res = subject.request(:hello, params)
        res.should == 'ok'
      end
    end
  end
end
