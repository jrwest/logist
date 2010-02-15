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
  end
end
