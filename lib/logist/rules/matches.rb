module Logist
  module Rules
    class Matches < Rule
      attr_reader :expression
      
      def initialize(for_field, expression)
        @expression = expression
        super for_field
      end
      
      def met_by?(entry)
        (entry.send @for) =~ @expression
      end
    end
  end
end