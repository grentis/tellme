class Helper

  def self.get_date_by_index(index)
    Date.today >> index.to_i
  end

  def self.get_index_by_date(year, month)
    now = Time.now
    date = DateTime.new(year, month, 1)
    if date > now
      return (date.year - now.year) * 12 - now.month + date.month
    else
      return -1 * (now.year - date.year) * 12 - now.month + date.month
    end
  end
end