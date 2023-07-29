class Connection < ApplicationRecord
  belongs_to :customer
  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts
end
