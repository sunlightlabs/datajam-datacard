require File.expand_path("../../spec_helper", __FILE__)
require "faraday/response/json_decoded"

describe Faraday::Response::JsonDecoded do
  let :test do
    Faraday.new do |builder|
      builder.response :json_decoded
      builder.adapter :test  do |stub|
        stub.get("/foo.json") { [200, {}, '{"foo": "bar"}'] }
      end
    end
  end

  it "decodes JSON response body if supplied and no error status code met" do
    resp = test.get("/foo.json")
    resp.env[:data]["foo"].should == "bar"
  end
end
