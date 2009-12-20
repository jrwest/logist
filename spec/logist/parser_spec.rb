require File.join(File.dirname(__FILE__), %w[.. spec_helper])

module Logist
  describe Parser do
    context "instantiation" do
      context "common log adapter" do
        it "should take symbol :common and use it to instantiate a common adapter" do
          LogAdapter.should_receive(:common_adapter)
          Parser.new(:common)  
        end
      end
      context "combined log adapter" do
        it "should take symbol :combined and use it to instantiate a combined adapter" do
          LogAdapter.should_receive(:combined_adapter)
          Parser.new(:combined)
        end
      end
    end
    context "parsing" do
      before(:each) do
        @parser = Parser.new(:common)  
      end
      context "single log" do
        before(:each) do
          @log_file = StringIO.new
        end
        it "should return an empty array if the log is empty" do
          entries = @parser.parse_entries(@log_file)
          entries.should == []
        end
        context "valid entries" do
          before(:each) do
            @log_file.puts '172.93.45.2 - - [01/Jan/2009:12:00:00 +0530] "GET /images/b.gif" 302 193'
            @log_file.puts '172.93.45.2 - - [02/Feb/2009:12:00:00 -0400] "GET /images/c.gif HTTP/1.1" 200 193'
            @log_file.rewind
          end
          it "should return an array of Entry objects parsed from valid entries" do
            entries = @parser.parse_entries(@log_file)
            entries.size.should == 2
            entries.each do |entry|
              entry.raw[:client].should == '172.93.45.2'
              entry.raw[:rfc1413].should be_nil
              entry.raw[:userid].should be_nil
            end
          end
          it "should take a block and pass each entry to the block" do
            count = 0
            @parser.parse_entries(@log_file) do |entry|
              entry.raw[:client].should == '172.93.45.2'
              entry.raw[:rfc1413].should be_nil
              entry.raw[:userid].should be_nil
              count += 1
            end
            count.should be 2
          end
        end
        context "handling invalid entries" do
          before(:each) do
            @log_file.puts '172.93.45.2 - - [01/Jan/2009:12:00:00 +0530] "GET /images/b.gif" 302 193'
            @log_file.puts 'Invalid Line'
            @log_file.rewind
          end
          it "should return an array of Entry objects with invalid entries not included" do
            entries = @parser.parse_entries(@log_file)
            entries.size.should == 1
            entries.each do |entry|
              entry.raw[:client].should == '172.93.45.2'
              entry.raw[:rfc1413].should be_nil
              entry.raw[:userid].should be_nil
            end
          end
          it "should pass invalid entries as nil to the block if given" do
            entries = []
            @parser.parse_entries(@log_file) do |entry|
              entries << entry
            end
            entries.size.should be 2
            entries.first.should be_instance_of(Logist::Entry)
            entries.last.should be_nil
          end
        end
      end
      context "multiple logs" do
        it "should take multiple log IO objects and treat them as one" do
          log_file1 = StringIO.new
          log_file2 = StringIO.new
          log_file1.puts '172.93.45.2 - - [01/Jan/2009:12:00:00 +0530] "GET /images/b.gif" 200 193'
          log_file1.puts '172.93.45.2 - - [01/Jan/2009:12:00:00 +0530] "GET /a.html" 200 193'
          log_file2.puts '127.0.0.1 - - [01/Jan/2009:12:00:00 +0530] "GET /b.html" 200 193'
          log_file2.puts '193.92.5.2 - - [01/Jan/2009:12:00:00 +0530] "GET /images/a.gif" 302 193'
          log_file1.rewind
          log_file2.rewind
          entries = @parser.parse_entries(log_file1, log_file2)
          entries.size.should == 4
        end
      end
    end
  end
end