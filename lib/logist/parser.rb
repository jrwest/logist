module Logist
  class Parser
    def parse_entries(*logs, &block)
      entries = []
      logs.each do |log|
        log.each_line do |line|
          entry = @adapter.parse_entry(line)
          entries << entry if entry
          if block_given?
            yield entry unless entry.nil?
          end
        end
      end
      entries
    end
     
    def initialize(format)
      @adapter = LogAdapter.send "#{format.to_s}_adapter".intern
    end
  end
end