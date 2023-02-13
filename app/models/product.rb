class Product < ApplicationRecord
  has_many :inventories, dependent: :destroy
  has_many :sales, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
