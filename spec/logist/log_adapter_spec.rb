require File.join(File.dirname(__FILE__), %w[.. spec_helper])
module Logist
  describe LogAdapter do
    context "Acts as factory" do
      it "should return an instance of itself when not given a format" do
        adapter = LogAdapter.new
        adapter.should be_instance_of(LogAdapter)
      end
    end
    context "entries" do
      context "#valid_entry?" do
        it "should return true if entry is not an emtpy string" do
          adapter = LogAdapter.new
          adapter.should be_valid_entry('not empty')
        end
        it "should return false if entry is empty string (which is default argument value)" do
          adapter = LogAdapter.new
          adapter.should_not be_valid_entry
          adapter.should_not be_valid_entry('')
        end
      end
      context "#parse_entry" do
        it "should return the same string passed if valid entry" do
          adapter = LogAdapter.new
          adapter.parse_entry("entry").should == "entry"
        end
        it "should return nil if entry is invalid" do
          adapter = LogAdapter.new
          adapter.parse_entry("").should be_nil
        end
      end
    end
  end
end