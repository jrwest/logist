require File.join(File.dirname(__FILE__), %w[.. spec_helper])

module Logist
  describe Rule do
    it "is for a field" do
      rule = Rule.new(:some_field)
      rule.for.should == :some_field
    end
    describe "checking against an entry" do
      let(:entry) { mock(Entry, :some_field => "abc") }
      before(:each) do
        @rule = Rule.new(:some_field)
      end
      it "always returns true because any entry meets the generic rule" do
        @rule.should be_met_by(entry)
      end
    end
  end
end