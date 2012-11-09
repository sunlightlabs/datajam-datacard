class Float
  def to_delimited(options={})
    options = {delimiter: ','}.merge(options)
    self.to_s.reverse.gsub(/(\d{3})(?=\d)/, "\\1#{options[:delimiter]}").reverse
  end
end