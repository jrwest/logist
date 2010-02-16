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
  end
end
