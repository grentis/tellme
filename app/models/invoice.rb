class Invoice < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :payments, order: [:year, :month]
  belongs_to :client

  validates :client, presence: true
  validates :number, presence: true
  validates :date, presence: true

  def balance
    self.amount - self.payments.paid.sum(:value)
  end

  def total_payments
    self.payments.sum(:value)
  end

  def num_payments
    self.payments.count
  end

  def total_eq_payments?
    self.amount - self.total_payments == 0
  end

  def paid?
    self.balance == 0
  end

  def has_expired?
    self.payments.expired.count > 0
  end
end
