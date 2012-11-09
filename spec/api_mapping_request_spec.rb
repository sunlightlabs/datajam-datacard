require File.expand_path('../spec_helper', __FILE__)

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
        params = { :phrase => 'capitol', :start_date => '2012-01-01' }

        Faraday::Connection.any_instance.expects(:get)
          .with('/api/dates.json', params)
          .returns('ok')

        res = subject.request(:word_over_time, params)
        res.should == 'ok'
      end
    end
  end
end
