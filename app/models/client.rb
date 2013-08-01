class Client < ActiveRecord::Base
  attr_accessible :name, :address, :iva, :cf, :payment_type, :bank, :abi, :cab, :hourly_cost, :note

  has_many :invoices, order: [:date, :number], dependent: :destroy
  has_many :payments, through: :invoices

  validates :name, presence: true

  def total_expired_payments
    self.payments.expired.sum(:value)
  end

  def total_payments
    self.payments.sum(:value)
  end

  def total_invoices
    self.invoices.sum(:amount)
  end
end
