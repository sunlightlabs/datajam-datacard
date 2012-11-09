require File.expand_path('../spec_helper', __FILE__)

describe Object do
  describe "#to_f_if_possible" do
    it "returns itself when invalid number" do
      "foo".to_f_if_possible.should == "foo"
    end

    it "returns itself converted to number if valid" do
      "31.11".to_f_if_possible.should == 31.11
    end
  end
end

describe Array do
  describe "#options" do
    it "returns empty hash with options used by table helpers" do
      [].options.should == {}
    end
  end
end

describe Float do
  describe "#to_delimited" do
    it "returns a string with thousands separators" do
      (123456789.0).to_delimited.should == "123,456,789.0"
    end
    it "takes a delimiter option" do
      (123456789.0).to_delimited(delimiter: '.').should == "123.456.789.0"
    end
  end
end