Logist::LogAdapter.build(:common) do
  def valid_entry?(entry = '') 
    entry =~ /^(.+) (.+|-) (.+|-) \[(\d{2})\/([A-z][a-z]{2})\/(\d{4}):(\d{2}):(\d{2}):(\d{2})\] "([A-Z]{3,}) (\/.*)( HTTP\/?\d?\.?\d?)?" (\d{3}) (\d*)$/ 
  end
end