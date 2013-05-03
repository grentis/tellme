class String
  def escape_single_quotes
    self.gsub(/[']/, %q(\\\'))
  end
end