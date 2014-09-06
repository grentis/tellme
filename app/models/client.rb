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

  def invoices_by_year(year)
    self.invoices.by_year(year - Time.now.year)
  end

  def total_invoices_by_year(year)
    self.invoices_by_year(year).sum(:amount)
  end

  def total_expired_payments_by_year(year)
    self.invoices_by_year(year).map(&:total_expired_payments).inject(0, :+)
  end
end
