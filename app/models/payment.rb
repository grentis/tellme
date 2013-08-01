class Payment < ActiveRecord::Base
  attr_accessible :v_date, :paid, :value, :note, :_destroy

  belongs_to :invoice
  has_one :client, through: :invoice

  scope :paid, where( paid: true )
  scope :expired, include: [{:invoice => :client}], conditions: ["paid = :paid and payments.date <= :date", { paid: false, date: Date.today }], order: [:date]
  scope :for_index, Proc.new { |index|
    d = Helper::get_date_by_index index
    includes([{:invoice => :client}]).where("payments.date >= :first and payments.date <= :last", { first: d.beginning_of_month, last: d.end_of_month }).order(:id) unless index.nil?
  }

  validates :v_date, presence: true
  validates :date, presence: true
  validates :value, numericality: true

  before_validation :date_format

  attr_accessor :v_date, :_destroy

  def expired?
    !self.paid && (self.date <= Date.today)
  end

  def should_be_deleted?
    @v_date.blank? && self.value.blank? && self.note.blank?
  end

  def value=(value)
    write_attribute(:value, value.to_s.gsub('.', '').gsub(',', '.'))
  end

  def v_date
    @v_date || ((I18n.localize(self.date, format: '%d %B %Y').titleize) unless self.date.blank?)
  end

  def v_date=(v_date)
    @v_date = v_date
    set_date
  end

  def index_in_invoice
    pos = 0
    invoice.payments.each do |payment|
      pos = pos + 1
      return pos if payment.id == self.id
    end
    return nil
  end

  private
    def date_format
      #set_date
    end

    def set_date
      if !@v_date.blank?
        begin
          temp = @v_date
          I18n.t("date.month_names").each_with_index do |m, i|
            unless m.nil?
              temp = temp.downcase.gsub(m.to_s, Date::MONTHNAMES[i])
            end
          end
          self.date = Date.strptime(temp, '%d %B %Y')
        rescue
          date_will_change!
          self.date + 1.day - 1.day
          errors.add(:v_date, "formato non valido")
        end
      else
        self.date = nil
      end
    end

end
