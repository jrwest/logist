module Logist
  class Parser
    def parse_entries(*logs, &block)
      entries = []
      logs.each do |log|
        log.each_line do |line|
          entry = @adapter.parse_entry(line)
          entries << entry if entry
          yield entry if block_given?
        end
      end
      entries
    end
     
    def initialize(format)
      @adapter = LogAdapter.send "#{format.to_s}_adapter".intern
    end
  end
end