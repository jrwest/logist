module Logist
  class Parser
    attr_reader :rulesets
     
    def conformed?(entry)
      retval = true
      rulesets.each do |ruleset|
        unless ruleset.conformed?(entry)
          retval = false
          break
        end
      end
      retval
    end
    
    def entries_must_conform_to(ruleset)
      @rulesets << ruleset
    end
    
    def initialize(format)
      @adapter = LogAdapter.send "#{format.to_s}_adapter".intern
      @rulesets = []
    end
    
    def parse_entries(*logs, &block)
      entries = []
      logs.each do |log|
        log.each_line do |line|
          entry = @adapter.parse_entry(line)
          is_conformed = conformed?(entry)
          entries << entry if (entry && is_conformed)
          if block_given?
            yield entry unless entry.nil? || (not is_conformed)
          end
        end
      end
      entries
    end
    
  end
end