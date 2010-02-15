require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

module Logist
  module Rules
    describe Exists do
      let(:entry) {mock(Entry, :some_field => "not nil")}
      before(:each) do 
        @exists_rule = Exists.new(:some_field)
      end
      describe "#met_by?" do
        it "returns true if the field is not nil" do
          @exists_rule.should be_met_by entry
        end
        it "returns false if the field is nil" do
          entry.stub!(:some_field).and_return(nil)
          @exists_rule.should_not be_met_by entry
        end
      end
    end
  end
end