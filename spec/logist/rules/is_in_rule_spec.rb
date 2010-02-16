require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

module Logist
  module Rules
    describe IsIn do
      let(:entry) {mock(Entry, :some_field => 2)}
      before(:each) do
        @isin_rule = IsIn.new(:some_field, [1, 2, 3])
      end
      it "is instantiated with a field and an array of objects" do
        @isin_rule.for.should == :some_field
        @isin_rule.values.should == [1, 2, 3]
      end
      describe "#met_by?" do
        it "returns true if the entry's value is in the array" do
          @isin_rule.should be_met_by entry
        end
        it "returns false if the entry's value is not in the array" do
          entry.stub(:some_field).and_return(4)
          @isin_rule.should_not be_met_by entry
        end
      end
    end
  end
end