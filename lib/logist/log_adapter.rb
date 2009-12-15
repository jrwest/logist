module Logist
  class LogAdapter
    def parse_entry(entry = "")
      return nil unless valid_entry?(entry)
      entry
    end
    
    def valid_entry?(entry = "")
      not entry.empty?
    end
  end
end