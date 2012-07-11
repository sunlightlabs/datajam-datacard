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
