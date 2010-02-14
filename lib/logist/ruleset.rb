module Logist
  class RuleSet
    attr_reader :name, :rules
    
    def initialize(name, rules = [])
      @name = name.to_s.split("_").map do |word|
        word.capitalize
      end.join(" ")
      @rules = rules
    end
    
    def conformed?(entry)
      rules.each do |rule|
        unless rule.met_by?(entry)
          return false
        end
      end
      true
    end
  end
end