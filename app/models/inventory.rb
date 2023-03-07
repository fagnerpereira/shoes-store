class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true
  validates :store, uniqueness: { scope: :product }

  def stock
    case
    when quantity < 20
      'low'
    when quantity < 60
      'middle'
    else
      'high'
    end
  end
end
