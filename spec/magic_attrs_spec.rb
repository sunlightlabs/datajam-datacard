require File.expand_path('../spec_helper', __FILE__)

describe Datajam::Datacard::MagicAttrs do
  subject do
    DummyMagicAttrs
  end

  describe ".attr_magic" do
    context "when list of names given" do
      it "registers magic attr writer for specified names" do
        subject.attr_magic :foo, :bar
        subject.new.tap do |inst|
          inst.foo "x"
          inst.foo.should == "x"
          inst.bar "y"
          inst.bar.should == "y"
        end
      end
    end

    context "when single name given" do
      it "registers magic attr writer for specified name" do
        subject.attr_magic :baz
        subject.new.tap do |inst|
          inst.baz "x"
          inst.baz.should == "x"
          inst.baz = "y"
          inst.baz.should == "y"
        end
      end
    end
  end
end
