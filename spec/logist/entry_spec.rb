require File.join(File.dirname(__FILE__), %w[.. spec_helper])
module Logist
  describe Entry do 
    before(:each) do 
      @december_1st = '01/Dec/2009:12:14:57 +0400'
      @january_2nd = '02/Jan/2010:23:59:00 +0400'
    end
    context "instantiation" do 
      it "should take a hash as its single optional argument" do 
      	lambda { Entry.new {} }.should_not raise_error
      	lambda { Entry.new }.should_not raise_error
      end
    end
    
    context "accessing entry data" do
     
      context "raw data" do
        before(:each) do 
          @raw_data = {:field => 'value', :field2 => 'value 2'}
          @entry = Entry.new(@raw_data)
        end
      
      	it "#raw should return hash entry was instantiated with" do 
      	  @entry.raw[:field].should == 'value'
      	  @entry.raw[:field2].should == 'value 2'
      	  @entry.raw[:nofield].should be_nil
      	end

        context "dot syntax" do
          it "should return values of keys passed as method names" do
      	    @entry.field.should == 'value'
      	    @entry.field2.should == 'value 2'
      	  end
      	  it "should still throw an error if a method is called and key does not exist in raw data" do
            lambda do
              @entry.missing_field
            end.should raise_error
      	  end
          it "should return nil for a field stored in raw as nil instead of throwing an error" do
            entry = Entry.new(:nilfield => nil)
            entry.nilfield.should be_nil
          end
        end

      	context "special fields" do 
      	  it "converts timestamp field to Time object when accessed using method call (does not modify original)" do 
      	    timestamped_entry = Entry.new(:timestamp => @december_1st)
      	    timestamped_entry.timestamp.should be_instance_of(Time)
      	    timestamped_entry.raw[:timestamp].should be_instance_of(@december_1st.class)  
      	  end
      	end
      end
      
      context "extracts from raw data" do 
      	context "from :timestamp field if provided" do
      	  before(:each) do 
      	    @entry1 = Entry.new(:timestamp => @december_1st)
      	    @entry2 = Entry.new(:timestamp => @january_2nd)
      	    @entry3 = Entry.new(:timestamp => '02/Abc/2010:23:69:57 +0400')
      	    @entry4 = Entry.new(:notimestamp => 'Some Data')
      	  end
      	  
      	  context "date" do     
      	    context "day in calendar month" do 
      	      it "should return proper day number for month" do 
      	        @entry1.day_in_calendar_month.should == 1
      	        @entry2.day_in_calendar_month.should == 2
      	      end
      	         
      	      it "should raise error if timestamp is invalid format" do 
      	        lambda do 
      	          @entry3.day_in_calendar_month
      	        end.should raise_error 
      	      end
      	    
      	      it "should return nil if no timestamp is given" do 
      	        @entry4.day_in_calendar_month.should be_nil
      	      end
      	    end
      	  
      	    context "month in calendar year" do 
      	  	  it "should return proper month number" do 
      	    	  @entry1.month_in_calendar_year.should == 12
      	    	  @entry2.month_in_calendar_year.should == 1 
      	    	end
      	    	
      	    	it "should raise error if timestamp is invalid format" do 
        	      lambda do 
        	        @entry3.month_in_calendar_year
        	      end.should raise_error 
        	    end
        	    
        	    it "should return nil if no timestamp is given" do 
        	      @entry4.month_in_calendar_year.should be_nil 
        	    end
        	  end
      	  
        	  context "year" do 
        	    it "should return proper year" do 
        	      @entry1.year.should == 2009
        	      @entry2.year.should == 2010
        	    end
      	    
        	    it "should raise an error if timestamp is invalid format" do 
        	      lambda do 
        	        @entry3.year
        	      end.should raise_error 
        	    end
      	    
      	      it "should return nil if no timestamp is given" do 
      	        @entry4.year.should be_nil 
      	      end
      	    end
      	  end
      	  context "time" do
      	    context "hour" do 
      	  	  it "should return proper hour (in 24 hour format)" do 
      	  	    @entry1.hour.should == 12
      	  	    @entry2.hour.should == 23
      	  	  end
      	  	
      	  	  it "should raise an error if timestamp is invalid format" do 
      	        lambda do 
      	          @entry3.hour
      	        end.should raise_error 
      	      end
      	    
      	      it "should return nil if no timestamp is given" do 
      	        @entry4.hour.should be_nil 
      	      end
      	    end
      	    
      	    context "minute" do 
      	      it "should return proper minute" do 
      	  	    @entry1.minute.should == 14
      	  	    @entry2.minute.should == 59
      	  	  end
      	  	
      	  	  it "should raise an error if timestamp is invalid format" do 
      	        lambda do 
      	          @entry3.minute
      	        end.should raise_error 
      	      end
      	    
      	      it "should return nil if no timestamp is given" do 
      	        @entry4.minute.should be_nil 
      	      end
      	    end
      	    
      	    context "second" do 
      	      it "should return proper second" do 
      	  	    @entry1.second.should == 57
      	  	    @entry2.second.should == 0
      	  	  end
      	  	
      	  	  it "should raise an error if timestamp is invalid format" do 
      	        lambda do 
      	          @entry3.second
      	        end.should raise_error 
      	      end
      	    
      	      it "should return nil if no timestamp is given" do 
      	        @entry4.second.should be_nil 
      	      end
      	    end
      	  end
      	end
      end
    end

    context "output" do

      context "to string" do
        it "should output of block key/value pairs when passed to puts" do
          entry1 = Entry.new(:key1 => "value 1", :key2 => "value 2", :key3 => "value 3")
          entry2 = Entry.new(:key4 => "value 4", :key5 => "value 5")
          entry1.to_s.should == <<-ENTRY
key1: value 1
key2: value 2
key3: value 3
ENTRY
          entry2.to_s.should == <<-ENTRY
key4: value 4
key5: value 5
ENTRY
        end
        it "should output keys in alphabetical order by default" do
          entry = Entry.new(:key5 => 'a b c', :key6 => 'b c d', :key7 => 'd e f')
          entry.to_s.should == <<-ENTRY
key5: a b c
key6: b c d
key7: d e f
ENTRY
        end
        context "sorting" do
          before(:each) do
            @entry = Entry.new(:key1 => "value 1", :key2 => "value 2", :key3 => "value 3")
          end
          it "should take an array of keys and output the key/value pairs in order given by array" do
            @entry.to_s([:key3, :key1, :key2]).should == <<-ENTRY
key3: value 3
key1: value 1
key2: value 2
ENTRY
          end
          it "by default, should supress the output of any keys not included in the array" do
            @entry.to_s([:key3, :key1]).should == <<-ENTRY
key3: value 3
key1: value 1
ENTRY
          end
          context "errors" do
            it "should raise an ArgumentError if the array contains a key not in the entry's raw data" do
              lambda do
                @entry.to_s([:key3, :key4])   
              end.should raise_error ArgumentError, "Key does not exist"
            end
          end
        end
      end
      context "to comma separated values string" do
        it "should output a csv line of values" do
          entry = Entry.new(:key1 => "value 1", :key2 => "value 2", :key3 => "value 3")
          entry.to_csv.should == "\"value 1\",\"value 2\",\"value 3\"\n"
        end
        it "should output values in alphabetical order" do
          entry = Entry.new(:key5 => 'a b c', :key6 => 'b c d', :key7 => 'd e f')
          entry.to_csv.should == "\"a b c\",\"b c d\",\"d e f\"\n"
        end
        it "should only quote necessary values (values containing spaces and commas)" do
          entry = Entry.new(:key1 => 'value1', :key2 => 'value 2', :key3 => 'value,3')
          entry.to_csv.should == "\"value 2\",\"value,3\",value1\n"
        end
        it "should escape double quotes" do
          entry = Entry.new(:key1 => 'value"1"', :key2 => 'value2')
          entry.to_csv.should == "\"value\\\"1\\\"\",value2\n"
        end
        it "should convert nil values to empty strings with no quotes" do
          entry = Entry.new(:key1 => 'value1', :key2 => nil, :key3 => 'value3')
          entry.to_csv.should == ",value1,value3\n"
        end
        context "sorting" do
          before(:each) do
            @entry = Entry.new(:key1 => "value 1", :key2 => "value 2", :key3 => "value 3")
          end
          it "should take an array of keys and output values in order given in array" do
            @entry.to_csv([:key3, :key1, :key2]).should == "\"value 3\",\"value 1\",\"value 2\"\n"
          end
          it "by default, should ignore any keys not in the given array" do
            @entry.to_csv([:key3, :key1]).should == "\"value 3\",\"value 1\"\n"
          end
          it "should convert nil values to empty strings with no quotes" do
            entry = Entry.new(:key1 => 'value1', :key2 => 'value2', :key3 => nil)
            entry.to_csv([:key1, :key3, :key2]).should == "value1,,value2\n"
          end
          context "errors" do
            it "should raise an ArgumentError if the array contains a key not in the entry's raw data" do
              lambda do
                @entry.to_csv([:key3, :key4])   
              end.should raise_error ArgumentError, "Key does not exist"
            end
          end
        end
      end
    end
  end
end
