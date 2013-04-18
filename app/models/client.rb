class Client < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :invoices, order: :date

  validates :name, presence: true
end
