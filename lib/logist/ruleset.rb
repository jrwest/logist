module Logist
  class RuleSet
    attr_reader :name, :rules
    
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
      @name = name.to_s.split("_").map do |word|
        word.capitalize
      end.join(" ")
      @rules = rules
    end
  end
end