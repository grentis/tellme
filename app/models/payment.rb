class Payment < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :invoice
  has_one :client, through: :invoice

  scope :paid, where( paid: true )
  scope :expired, conditions: ["paid = :paid and (year < :year or (year = :year and month < :month))", { paid: false, year: Time.now.year, month: Time.now.month }]

  validates :year, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2000, less_than_or_equal_to:2050 }
  validates :month, presence: true, inclusion: { in: (1..12), message: "non e' un mese valido" }
  validates :value, numericality: true

  def expired?
    now = Time.now
    !self.paid && (self.year < now.year || (self.year == now.year && self.month < now.month))
  end
end
