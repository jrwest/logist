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
           'client rfc1413 userid [01/Jan/2010:00:00:00] "GET /a.html HTTP/1.1" 200 1493',
           '172.93.45.2 - - [01/Jan/2009:12:00:00] "GET /images/b.gif" 302 193',
           '172.93.45.2 - - [02/Feb/2009:12:00:00] "GET /images/c.gif HTTP/1.1" 200 193',
           'my.host.name - - [02/Mar/2010:14:30:21] "POST /services HTTP/1.1/" 200 1493'
         ]
         valid_entries.each do |entry|
           adapter.should be_valid_entry(entry)
         end
       end
       it "should return false if the entry is not in valid common log format" do
         adapter = LogAdapter.common_adapter
         invalid_entries = [
           '- - [01/Dec/2009:00:00:00] "GET /a.html HTTP/1.1" 200 1234',
           '127.0.0.1 - [01/Dec/2009:00:00:00] "GET /a.html HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec/2009:00:00] "GET /a.html HTTP/1.1" 200 1234',
           'my.host.name - - [01/Dec:00:00:00] "GET /a.html HTTP/1.1" 200 1234',
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
   end
 end
end