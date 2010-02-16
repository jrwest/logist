module Logist
  module Rules
    class IsIn < Rule
      attr_reader :values
      
      def initialize(for_field, values)
        @values = values
        super for_field
      end
      
      def met_by?(entry)
        @values.include?((entry.send @for))
      end
    end
  end
end