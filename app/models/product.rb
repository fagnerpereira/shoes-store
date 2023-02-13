class Product < ApplicationRecord
  has_many :inventories, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
