module Logist
  class RuleSet
    attr_reader :name, :rules
    
    @all = {}
    
    def self.[](set_name)
      @all[set_name]
    end
    
    def add(rule)
      @rules << rule
    end
    
    def conformed?(entry)
      rules.each do |rule|
        unless rule.met_by?(entry)
          return false
        end
      end
      true
    end
    
    def initialize(name, rules = [])
      RuleSet.add_to_global_sets(name, self)
      @name = name.to_s.split("_").map do |word|
        word.capitalize
      end.join(" ")
      @rules = rules
    end
    
    private
      
      def self.add_to_global_sets(name, ruleset)
        @all[name] = ruleset
      end
  end
end