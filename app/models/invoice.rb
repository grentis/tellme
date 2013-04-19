class Invoice < ActiveRecord::Base
  attr_accessible :amount, :number, :date, :payments_attributes

  has_many :payments, order: [:year, :month], dependent: :destroy
  belongs_to :client

  validates :client, presence: true
  validates :number, presence: true
  validates :date, presence: true

  accepts_nested_attributes_for :payments, allow_destroy: true

  before_validation :mark_payments_for_removal

  def balance
    self.amount - self.payments.paid.sum(:value)
  end

  def total_payments
    self.payments.sum(:value)
  end

  def num_payments
    self.payments.count
  end

  def split_valid?
    self.amount - self.total_payments == 0
  end

  def paid?
    self.balance == 0
  end

  def has_expired?
    self.payments.expired.count > 0
  end


  private
    def mark_payments_for_removal
      self.payments.each do |p|
        p.mark_for_destruction if p.should_be_deleted?
      end
    end
end
