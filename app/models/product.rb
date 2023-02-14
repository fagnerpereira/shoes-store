class Product < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :sales, dependent: :nullify

  validates :name, :price, presence: true
  validates :name, uniqueness: true
end
