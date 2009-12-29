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
      	
      	it "should return values of keys passed as method names" do 
      	  @entry.field.should == 'value'
      	  @entry.field2.should == 'value 2'
      	end
      	
      	it "should still throw an error if a method is called and key does not exist in raw data" do 
          lambda do 
            @entry.missing_field
          end.should raise_error
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
      it "should output of block key/value pairs when passed to puts"
      it "should output a csv line of values" 
    end
  end
end