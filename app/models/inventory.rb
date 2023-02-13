class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true
  validates :store, uniqueness: { scope: :product }
end
