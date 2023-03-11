class Inventory < ApplicationRecord
  belongs_to :store
  belongs_to :product

  validates :quantity, presence: true
  validates :store, uniqueness: { scope: :product }

  def stock
    if quantity < 20
      'low'
    elsif quantity < 60
      'middle'
    else
      'high'
    end
  end
end
