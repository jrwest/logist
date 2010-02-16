require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe "RuleSets DSL" do
  include Logist::DSL::RuleSets
  describe "#ruleset" do
    it "returns a RuleSet instance with the given name and no rules given an empty block" do
      my_ruleset = ruleset :name do
        #no code
      end
      my_ruleset.should be_instance_of(::Logist::RuleSet)
      my_ruleset.name.should == "Name"
    end
    it "returns a RuleSet instance with the given name and no rules given no block" do
      my_ruleset = ruleset :name
      my_ruleset.should be_instance_of(Logist::RuleSet)
      my_ruleset.name.should == "Name"
    end
    it "takes a block whose receiver becomes an instance of RuleSetBuilder" do
      self_ptr = nil
      ruleset :name do
        self_ptr = self
      end
      self_ptr.should be_instance_of(Logist::DSL::RuleSets::RuleSetBuilder)
    end
    describe "RuleSet Builder" do
      it "tries to convert calls nonexistent methods to instantiations of rules" do
        my_ruleset = ruleset :name do 
          exists :some_field
        end
        rule = my_ruleset.rules.first
        rule.should be_kind_of(Logist::Rule)
        rule.for.should == :some_field
      end
      it "passes all arguments to the rule" do
        my_ruleset = ruleset :name do 
          matches :some_field, /abc/
        end
        rule = my_ruleset.rules.first
        rule.expression.should == /abc/
      end
      it "still errors on nonexistent methods" do
        lambda {
          ruleset :name do
            nonexistent_rule :errors
          end
        }.should raise_error NoMethodError
      end
    end
    it "works in a full example" do
      example_entry = mock(Logist::Entry, :first_field      => "a",
                                          :second_field     => 2,
                                          :third_field      => "abc",
                                          :fourth_field     => "abc")

      ruleset :example_ruleset do 
        exists          :first_field
        is_in           :second_field, [1, 2, 3]
        matches         :third_field, /^abc$/
        does_not_match  :fourth_field, /^def$/
      end
      Logist::RuleSet[:example_ruleset].rules.size.should == 4
      Logist::RuleSet[:example_ruleset].should be_conformed(example_entry)
      
      example_entry.stub(:second_field).and_return(5)
      Logist::RuleSet[:example_ruleset].should_not be_conformed(example_entry)
    end
  end
end
