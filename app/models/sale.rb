class Sale < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true
end
