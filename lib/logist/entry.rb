module Logist
  class Entry
    attr_reader :raw
    
    def day_in_calendar_month
      return unless timestamp
      timestamp.mday
    end
    
    def month_in_calendar_year
      return unless timestamp
      timestamp.month
    end
    
    def hour
      return unless timestamp
      timestamp.hour
    end
    
    def initialize(raw_data = {})
      @raw = raw_data
    end
    
    def minute
      return unless timestamp
      timestamp.min
    end
    
    def second
      return unless timestamp
      timestamp.sec
    end
    
    def timestamp
    	@timestamp ||= timestamp_to_date 
    end
    
    def year
      return unless timestamp
      timestamp.year
    end
    
    private
      def method_missing(method, *args, &block)
      	super(method, *args, &block) unless @raw[method]
      	@raw[method]
      end
      
      def timestamp_to_date 
      	return unless timestamp = @raw[:timestamp]
      	date, hour, minute, second, timezone = timestamp.split(/[:\s]/)
      	day, month, year = date.split('/')
      	Time.mktime(year.to_i, %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec].index(month) + 1, day.to_i, hour.to_i, minute.to_i, second.to_i)
      end
  end
end