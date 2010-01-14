shared_examples_for "Any LogAdapter that can validate entries" do
  context "#valid_entry?" do
    it "should return true if the entry is in valid combined log format" do
      @valid_entries.each do |entry|
        @adapter.should be_valid_entry(entry)
      end
    end
    it "should return false if the entry is not in valid combined log format" do
      @invalid_entries.each do |entry|
        @adapter.should_not be_valid_entry(entry)
      end
    end
  end
end