class Invoice < ActiveRecord::Base
  attr_accessible :amount, :number, :date, :payments_attributes, :client_id, :note, :year

  has_many :payments, order: [:date], dependent: :destroy
  belongs_to :client

  scope :by_year, Proc.new { |year|
    includes([:client]).where("year = :year", { year: Date.today.year + year }) unless year.nil?
  }

  validates :client, presence: true
  validates :client_id, presence: true
  validates :number, presence: true, uniqueness: { scope: :year, message: 'n. fattura già inserito' }
  validates :date, presence: true
  validates :amount, presence: true
  validate :validate_payments

  accepts_nested_attributes_for :payments, allow_destroy: true

  before_validation :mark_payments_for_removal, :extract_year

  def balance
    self.amount - self.total_payments
  end

  def total_expired_payments
    self.payments.expired.sum(:value)
  end

  def total_payments
    self.payments.sum(:value)
  end

  def amount=(amount)
    write_attribute(:amount, amount.to_s.gsub('.', '').gsub(',', '.'))
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
        p.destroy if p.should_be_deleted?
      end
    end

    def extract_year
      self.year = self.date.nil? ? Time.now.year : self.date.year
    end

    def validate_payments
      errors.add(:payments, "specificare almeno una rata") if self.payments.reject{ |p| p.destroyed? || p.marked_for_destruction? }.length < 1
    end
end
