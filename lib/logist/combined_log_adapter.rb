Logist::LogAdapter.build(:combined) do
  def valid_entry?(entry = '')
    entry =~ /^(.+) (.+|-) (.+|-) \[(\d{2})\/([A-z][a-z]{2})\/(\d{4}):(\d{2}):(\d{2}):(\d{2}) (\+\d{4}|-\d{4})\] "([A-Z]{3,}) (\/.*)( HTTP\/?\d?\.?\d?)?" (\d{3}) (\d+)\s?("[^"]*")?\s?("[^"]*")?\s?("[^"]*")?$/
  end    
end