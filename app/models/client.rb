class Client < ActiveRecord::Base
  attr_accessible :name, :address, :iva, :cf, :payment_type, :bank, :abi, :cab, :hourly_cost, :note

  has_many :invoices, order: :date, dependent: :destroy

  validates :name, presence: true
end
