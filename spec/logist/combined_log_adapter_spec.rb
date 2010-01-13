require File.join(File.dirname(__FILE__), %w[.. spec_helper])

module Logist
  describe CombinedLogAdapter do
    before(:each) do
      @adapter = LogAdapter.combined_adapter
    end
    context "instantiation" do
      it "should be instantiated through factory method combined_adapter" do
        @adapter.should be_instance_of(Logist::CombinedLogAdapter)
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
          valid_entries.each do |entry|
            @adapter.should be_valid_entry(entry)
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
          invalid_entries.each do |entry|
            @adapter.should_not be_valid_entry(entry)
          end
        end
      end
      context "parsing entries" do
        it "should correctly parse all fields and additionally merge the datetime fields in a timestamp field" do
          Entry.should_receive(:new).with({:client => 'client',
                                            :rfc1413 => 'rfc1413',
                                            :userid => 'userid',
                                            :day => '01',
                                            :month => 'Jan',
                                            :year => '2010',
                                            :hour => '00',
                                            :minute => '00',
                                            :second => '00',
                                            :tzn => '+0400',
                                            :httpmethod => 'GET',
                                            :resource => '/a.html',
                                            :protocol => 'HTTP/1.1',
                                            :status_code => '200',
                                            :response_size => '1493',
                                            :referrer => 'referrer',
                                            :user_agent => 'user agent',
                                            :cookies => 'cookies',
                                            :timestamp => '01/Jan/2010:00:00:00 +0400'})
           @adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent" "cookies"')
        end
        it "should return nil if the entry is invalid" do
          @adapter.parse_entry('invalid').should be_nil
        end
        it "should correctly handle missing cookies field, setting values to nil" do
          Entry.should_receive(:new).with({:client => 'client',
                                            :rfc1413 => 'rfc1413',
                                            :userid => 'userid',
                                            :day => '01',
                                            :month => 'Jan',
                                            :year => '2010',
                                            :hour => '00',
                                            :minute => '00',
                                            :second => '00',
                                            :tzn => '+0400',
                                            :httpmethod => 'GET',
                                            :resource => '/a.html',
                                            :protocol => 'HTTP/1.1',
                                            :status_code => '200',
                                            :response_size => '1493',
                                            :referrer => 'referrer',
                                            :user_agent => 'user agent',
                                            :cookies => nil,
                                            :timestamp => '01/Jan/2010:00:00:00 +0400'})
           @adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html HTTP/1.1" 200 1493 "referrer" "user agent"')
        end
        it "should correctly handle missing cookies and user agent field, setting values to nil" do
          Entry.should_receive(:new).with({:client => 'client',
                                            :rfc1413 => 'rfc1413',
                                            :userid => 'userid',
                                            :day => '01',
                                            :month => 'Jan',
                                            :year => '2010',
                                            :hour => '00',
                                            :minute => '00',
                                            :second => '00',
                                            :tzn => '+0400',
                                            :httpmethod => 'GET',
                                            :resource => '/a.html',
                                            :protocol => 'HTTP/1.1',
                                            :status_code => '200',
                                            :response_size => '1493',
                                            :referrer => 'referrer',
                                            :user_agent => nil,
                                            :cookies => nil,
                                            :timestamp => '01/Jan/2010:00:00:00 +0400'})
           @adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html HTTP/1.1" 200 1493 "referrer"')
        end
        it "should correctly handle missing trailing fields (in common log format), setting values to nil" do
          Entry.should_receive(:new).with({:client => 'client',
                                            :rfc1413 => 'rfc1413',
                                            :userid => 'userid',
                                            :day => '01',
                                            :month => 'Jan',
                                            :year => '2010',
                                            :hour => '00',
                                            :minute => '00',
                                            :second => '00',
                                            :tzn => '+0400',
                                            :httpmethod => 'GET',
                                            :resource => '/a.html',
                                            :protocol => 'HTTP/1.1',
                                            :status_code => '200',
                                            :response_size => '1493',
                                            :referrer => nil,
                                            :user_agent => nil,
                                            :cookies => nil,
                                            :timestamp => '01/Jan/2010:00:00:00 +0400'})
           @adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html HTTP/1.1" 200 1493')
        end
        it "should correctly handle missing HTTP protocol, setting value to nil" do
           Entry.should_receive(:new).with({:client => 'client',
                                            :rfc1413 => 'rfc1413',
                                            :userid => 'userid',
                                            :day => '01',
                                            :month => 'Jan',
                                            :year => '2010',
                                            :hour => '00',
                                            :minute => '00',
                                            :second => '00',
                                            :tzn => '+0400',
                                            :httpmethod => 'GET',
                                            :resource => '/a.html',
                                            :protocol => nil,
                                            :status_code => '200',
                                            :response_size => '1493',
                                            :referrer => 'referrer',
                                            :user_agent => 'user agent',
                                            :cookies => 'cookies',
                                            :timestamp => '01/Jan/2010:00:00:00 +0400'})
           @adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html" 200 1493 "referrer" "user agent" "cookies"')  
        end
      end
    end
  end
end