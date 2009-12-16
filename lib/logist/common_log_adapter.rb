Logist::LogAdapter.build(:common) do
  def valid_entry?(entry = '') 
    entry =~ /^(.+) (.+|-) (.+|-) \[(\d{2})\/([A-z][a-z]{2})\/(\d{4}):(\d{2}):(\d{2}):(\d{2}) (\+\d{4}|-\d{4})\] "([A-Z]{3,}) (\/.*)( HTTP\/?\d?\.?\d?)?" (\d{3}) (\d*)$/ 
  end

  def parse_entry(entry = '') 
    field_data = entry.match(/^(.+) (.+|-) (.+|-) \[(\d{2})\/([A-z][a-z]{2})\/(\d{4}):(\d{2}):(\d{2}):(\d{2}) (\+\d{4}|-\d{4})\] "([A-Z]{3,}) (\/\S*)( HTTP\/?\d?\.?\d?)?" (\d{3}) (\d*)$/)
    entry_data = {}
    fields = [:client, :rfc1413, :userid, :day, :month, :year, :hour, :minute, :second, :tzn, :httpmethod, :resource, :protocol, :status_code, :response_size, :timestamp]
    field_data[1..field_data.size - 1].each_with_index do |field, index|
      entry_data[fields[index]] = field
      end
    Logist::Entry.new(entry_data)
  end
end