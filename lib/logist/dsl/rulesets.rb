module Logist
  module DSL
    module RuleSets
      def ruleset(name, &block)
        builder = RuleSetBuilder.new(RuleSet.new(name))
        if block 
          builder.instance_eval(&block)
        end
        builder.ruleset
      end
      class RuleSetBuilder
        attr_reader :ruleset
        def initialize(ruleset)
          @ruleset = ruleset
        end
      end
    end
  end
end