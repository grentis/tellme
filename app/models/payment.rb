class Payment < ActiveRecord::Base
  attr_accessible :v_date, :paid, :value, :note, :_destroy

  belongs_to :invoice
  has_one :client, through: :invoice

  scope :paid, where( paid: true )
  scope :expired, conditions: ["paid = :paid and (year < :year or (year = :year and month < :month))", { paid: false, year: Time.now.year, month: Time.now.month }]

  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2000, less_than_or_equal_to:2050 }
  validates :v_date, presence: true
  validates :month, presence: true
  validates :month, inclusion: { in: (1..12), message: (I18n.t 'errors.messages.invalid') }, unless: Proc.new { |a| !a.month.blank? }
  validates :value, numericality: true

  attr_accessor :v_date, :_destroy

  def expired?
    now = Time.now
    !self.paid && (self.year < now.year || (self.year == now.year && self.month < now.month))
  end

  def should_be_deleted?
    self.year.blank? && self.month.blank? && self.value.blank? && self.note.blank?
  end

  def value=(value)
    write_attribute(:value, value.to_s.gsub(',', '.'))
  end

  def v_date
    @v_date || ([ I18n.t("date.month_names")[self.month].camelize, self.year ].join(' ')) unless self.month.blank? or self.year.blank?
  end

  def v_date=(v_date)
    if !v_date.blank?
      split = v_date.split(' ', 2)
      if split.size() == 2
        self.month = I18n.t("date.month_names").index(split.first.downcase)
        self.year = split.last
      else
        self.month = nil
        self.year = nil
      end
    else
      self.month = nil
      self.year = nil
    end
  end

end
