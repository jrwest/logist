require File.join(File.dirname(__FILE__), %w[.. spec_helper])

module Logist
  describe CombinedLogAdapter do
    context "instantiation" do
      it "should be instantiated through factory method combined_adapter" do
        adapter = LogAdapter.combined_adapter
        adapter.should be_instance_of(Logist::CombinedLogAdapter)
      end
    end
    context "entries" do
      context "#valid_entry?" do
        it "should return true if the entry is in valid combined log format" do
          valid_entries = [
                    'client rfc1413 userid [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent" "cookies"',
                    'client rfc1413 userid [01/Jan/2010:12:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent"',
                    'client rfc1413 userid [01/Jan/2010:14:45:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer"',
                    'client rfc1413 userid [01/Jan/2010:12:23:34 -0400] "GET /a.html HTTP/1.1" 200 1493',
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "" "user agent" "cookies"',
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "" "cookies"',
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent" ""',
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "GET /a.gif" 200 123 "http://www.referrer.com" "user agent" "cookies"'
                  ]
          adapter = LogAdapter.combined_adapter
          valid_entries.each do |entry|
            adapter.should be_valid_entry(entry)
          end
        end
        it "should return false if the entry is not in valid combined log format" do
          invalid_entries = [
                    'rfc1413 userid [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent" "cookies"',
                    'client - [01/Jan/2010:12:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent"',
                    'client rfc1413 userid [01/Jan/:14:45:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer"',
                    'client rfc1413 userid [01/Jan/2010:12:23:34 -0400] "GET HTTP/1.1" 200 1493',
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 notquoted',
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "/a.html HTTP/1.1" 200 1493 "referrer" "" "cookies"',
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent" "',   #no last closing double quote
                    '127.0.0.1 - - [01/Jan/2010:00:00:00 -0400] "GET /a.gif" 123 "http://www.referrer.com" "user agent" "cookies"'
                  ]
          adapter = LogAdapter.combined_adapter
          invalid_entries.each do |entry|
            adapter.should_not be_valid_entry(entry)
          end
        end
      end
    end
  end
end