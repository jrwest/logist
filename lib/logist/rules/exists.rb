module Logist
  module Rules
    class Exists < Rule
      def met_by?(entry)
        not (entry.send @for).nil?
      end
    end
  end
end