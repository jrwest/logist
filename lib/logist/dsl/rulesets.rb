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
        
        def method_missing(method, *args)
          if not (klass = get_rule_class(method)).nil?
            @ruleset.add klass.new(*args)
          else
            super(method, *args)
          end
        end
        
        private
        
          def get_rule_class(sym, base = Logist::Rules)
             base.const_get sym.to_s.split(/_/).map { |w| w.capitalize}.join('').to_sym
          rescue
             nil
          end
      end
    end
  end
end