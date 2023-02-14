class Product < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :sales, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
