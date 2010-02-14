require File.join(File.dirname(__FILE__), %w[.. spec_helper])

module Logist
  describe RuleSet do
    before(:each) do
      @rset = RuleSet.new(:my_ruleset) 
    end
    it "has a name" do 
      @rset.name.should == "My Ruleset"
    end
    it "has a list of rules" do
      some_rule = mock(Rule)
      another_rset = RuleSet.new(:my_ruleset, [some_rule])
      @rset.rules.should == []
      another_rset.rules.should == [some_rule]
    end
    context "checking agains an entry" do
      let(:entry) { mock(Entry).as_null_object }
      let(:rule1) { mock(Rule).as_null_object }
      let(:rule2) { mock(Rule).as_null_object }
      before(:each) do
        @rset = RuleSet.new(:my_ruleset, [rule1, rule2])
      end
      context "when each entry meets each rule" do
        before(:each) do
          @rset.rules.each do |rule|
            rule.stub!(:met_by?).and_return(true)
          end
        end
        it "returns true if an entry conforms to the ruleset" do
          @rset.should be_conformed(entry)
        end
      end
      context "when an entry does not meet a rule" do
        before(:each) do
          rule2.stub!(:met_by?).and_return(false)
        end
        it "returns false if an entry does not conform to a ruleset" do
          @rset.should_not be_conformed(entry)
        end
      end
    end
  end
end