module Logist
  class Entry
    attr_reader :raw
    
    def day_in_calendar_month
      timestamp.mday if timestamp
    end
    
    def month_in_calendar_year
      timestamp.month if timestamp
    end
    
    def hour
      timestamp.hour if timestamp
    end
    
    def initialize(raw_data = {})
      @raw = raw_data
    end
    
    def minute
      timestamp.min if timestamp
    end
    
    def second
      timestamp.sec if timestamp
    end
    
    def timestamp
    	@timestamp ||= timestamp_to_date 
    end

    def to_csv(sort_keys = [])
      if sort_keys.size == 0
        values = raw.values.map{ |val| (val.nil?) ? '' : val}.sort
      else
        values = sort_keys.inject([]) do |values_arr, key|
          raise ArgumentError, "Key does not exist" unless raw.has_key?(key)
          values_arr << raw[key]  
        end
      end
      values.inject("") do |str, value|
        (value =~ /[,\s"]/) ? str + "\"#{value.gsub('"', "\\\"")}\"," : str + "#{value},"
      end.sub(/.$/, '') + "\n"
    end

    def to_s(sort_keys = [])
      s = ""
      if sort_keys.size == 0
        raw.sort {|a, b| a.to_s <=> b.to_s}.each do |key, value|
          s += "#{key}: #{value}\n"
        end
      else
        sort_keys.each do |key|
          raise ArgumentError, "Key does not exist" unless raw[key]
          s += "#{key}: #{raw[key]}\n"
        end
      end
      s
    end
    
    def year
      timestamp.year if timestamp
    end
    
    private
      def method_missing(method, *args, &block)
      	super(method, *args, &block) unless @raw.has_key?(method)
      	@raw[method]
      end
      
      def timestamp_to_date 
      	return unless timestamp = @raw[:timestamp]
      	day, month, year, hour, minute, second, timezone = timestamp.split(/[\/:\s]/)
        Time.mktime(year.to_i, %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].index(month) + 1, day.to_i, hour.to_i, minute.to_i, second.to_i)
      end
  end
end