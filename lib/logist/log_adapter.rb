module Logist
  class LogAdapter
    @@adapters = {}

    class << self
      def adapters
        @@adapters
      end

      def build(sym, superclass = Logist::LogAdapter, &block)
        subclass = Class.new(superclass, &block)
        subclass.register_adapter(sym)
        Logist.const_set("#{sym.to_s.capitalize}LogAdapter", subclass)
        (class << self; self; end).instance_eval do
          define_method("#{sym.to_s}_adapter".intern) { subclass.new }
        end
      end

      protected
        def register_adapter(sym)
          @@adapters[sym] = self
        end
    end
    
    def parse_entry(entry = "")
      return nil unless valid_entry?(entry)
      entry
    end
    
    def valid_entry?(entry = "")
      not entry.empty?
    end
    
  end
end