require File.join(File.dirname(__FILE__), %w[.. spec_helper])

module Logist
  describe RuleSet do
    it "has a name"
    it "has a list of rules"
    context "checking agains an entry" do
      it "returns true if an entry conforms to the ruleset"
      it "returns false if an entry does not conform to a ruleset"
    end
  end
end