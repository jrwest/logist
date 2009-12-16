require File.join(File.dirname(__FILE__), %w[.. spec_helper])
module Logist
 describe CommonLogAdapter do
   context "instantiation" do
     it "should be instantiated through the factory method common_adapter" do
       adapter = LogAdapter.common_adapter
       adapter.should be_instance_of(Logist::CommonLogAdapter)
     end
   end
   context "entries" do
     context "#valid_entry?" do
       it "should return true if the entry is valid common log format" do
         adapter = LogAdapter.common_adapter
         valid_entries = [
           'client rfc1413 userid [01/Jan/2010:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1493',
           '172.93.45.2 - - [01/Jan/2009:12:00:00 +0530] "GET /images/b.gif" 302 193',
           '172.93.45.2 - - [02/Feb/2009:12:00:00 -0400] "GET /images/c.gif HTTP/1.1" 200 193',
           'my.host.name - - [02/Mar/2010:14:30:21 -0400] "POST /services HTTP/1.1/" 200 1493'
         ]
         valid_entries.each do |entry|
           adapter.should be_valid_entry(entry)
         end
       end
       it "should return false if the entry is not in valid common log format" do
         adapter = LogAdapter.common_adapter
         invalid_entries = [
           '- - [01/Dec/2009:00:00:00] "GET /a.html HTTP/1.1" 200 1234',
           '127.0.0.1 - [01/Dec/2009:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec/2009:00:00 -0400] "GET /a.html HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec:00:00:00 -0400] "GET /a.html HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec/2010:00:00:00] "GET /a.html HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec/2009:00:00:00] "/a.html HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec/2009:00:00:00] "GET HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec/2009:00:00:00] "GET /a.html HTTP/1.1" nan 1234',
           'my.host.name - - [01/Dec/2009:00:00:00] "GET /a.html HTTP/1.1" 200 nan'
         ]
         invalid_entries.each do |entry|
           adapter.should_not be_valid_entry(entry)
         end
       end
     end
     context "parsing entries" do
       it "should return an instance of Logist:Entry if valid" do
         adapter = LogAdapter.common_adapter
         adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html HTTP/1.1" 200 1493').should be_instance_of(Logist::Entry)
       end
       it "should correctly parse all fields and additionally merge the datetime fields in a timestamp fiend" do
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
                                          :timestamp => '01/Jan/2010:00:00:00 +0400'})
         adapter = LogAdapter.common_adapter
         adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html HTTP/1.1" 200 1493')
       end
       it "should create the timestamp field in a format that Entry can convert to a non nil instance" do
         adapter = LogAdapter.common_adapter
         entry = adapter.parse_entry('client rfc1413 userid [01/Jan/2010:00:00:00 +0400] "GET /a.html HTTP/1.1" 200 1493')
         entry.timestamp.should_not be_nil
       end
       it "should convert emtpy entries (-) to nil" do
         pending
       end
       it "should be able to handle an entry with no protocol" do
        pending
       end
     end
   end
 end
end