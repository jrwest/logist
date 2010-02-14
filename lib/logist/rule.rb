module Logist
  class Rule
    attr_reader :for
    def initialize(for_field)
      @for = for_field
    end
    
    def met_by?(entry)
      true
    end
  end
end