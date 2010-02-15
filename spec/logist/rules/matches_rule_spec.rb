require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

module Logist
  module Rules
    describe Matches do
      let(:entry) {mock(Entry, :some_field => "abc")}
      before(:each) do
        @match_rule = Matches.new(:some_field, /^abc$/)
      end
      it "is instanatiated with a field and a regexp" do
        @match_rule.for.should == :some_field
        @match_rule.expression.should == /^abc$/
      end
      describe "#met_by?" do
        it "returns true if the field's value matches the expression" do
          @match_rule.should be_met_by entry
        end
        it "returns false if the field's value does not match the expression" do
          entry.stub!(:some_field).and_return("def")
          @match_rule.should_not be_met_by entry
        end
      end
    end
  end
end