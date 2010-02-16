require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

module Logist
  module Rules
    describe DoesNotMatch do
      let(:entry) {mock(Entry, :some_field => "abc")}
      before(:each) do
        @dnm_rule = DoesNotMatch.new(:some_field, /^def$/)
      end
      it "is instantiated with a field and a regexp" do
        @dnm_rule.for.should == :some_field
        @dnm_rule.expression.should == /^def$/
      end
      describe "#met_by?" do
        it "returns true if the field's content does not match the expression" do
          @dnm_rule.should be_met_by entry
        end
        it "returns false if the field's content does match the expression" do
          entry.stub(:some_field).and_return("def")
          @dnm_rule.should_not be_met_by entry
        end
      end
    end
  end
end