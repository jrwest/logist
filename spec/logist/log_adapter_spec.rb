require File.join(File.dirname(__FILE__), %w[.. spec_helper])
module Logist
  describe LogAdapter do
    context "Acts as factory" do
      it "should return an instance of itself when new is called" do
        adapter = LogAdapter.new
        adapter.should be_instance_of(Logist::LogAdapter)
      end
      it "should provide a method for building subclasses" do
        LogAdapter.build(:test)
        subclass = nil
        lambda do
          subclass = Logist.const_get(:TestLogAdapter)
        end.should_not raise_error
        subclass.should == Logist::TestLogAdapter
      end
      it "should add a class factory method named the same as the symbol" do
        LogAdapter.build(:test)
        adapter = LogAdapter.test_adapter
        adapter.should be_kind_of(Logist::TestLogAdapter)
      end
      it "should allow a block to passed to the build method so instance methods of the subclass can be defined" do
        LogAdapter.build(:test) do
          def test_method
          end
        end
        adapter = LogAdapter.test_adapter
        adapter.should respond_to(:test_method)
      end
    end
    context "entries" do
      before(:each) do
        @adapter = LogAdapter.new
        @valid_entries = ['not empty']
        @invalid_entries = ['']
      end
      
      it_should_behave_like "Any LogAdapter that can validate entries"
      
      context "#parse_entry" do
        it "should return the same string passed if valid entry" do
          @adapter.parse_entry("entry").should == "entry"
        end
        it "should return nil if entry is invalid" do
          @adapter.parse_entry("").should be_nil
        end
      end
    end
  end
end