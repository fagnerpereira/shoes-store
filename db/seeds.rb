# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Store.destroy_all if Store.any?
Store.insert_all([
  { name: 'ALDO Destiny USA Mall' },
  { name: 'ALDO Centre Eaton' },
  { name: 'ALDO Pheasant Lane Mall' },
  { name: 'ALDO Holyoke Mall' },
  { name: 'ALDO Maine Mall' },
  { name: 'ALDO Crossgates Mall' },
  { name: 'ALDO Burlington Mall' },
  { name: 'ALDO Solomon Pond Mall' },
  { name: 'ALDO Auburn Mall' },
  { name: 'ALDO Waterloo Premium Outlets' }
])

products = [
  'ADERI', 'MIRIRA', 'CAELAN',
  'BUTAUD', 'SCHOOLER', 'SODANO',
  'MCTYRE', 'CADAUDIA', 'RASIEN',
  'WUMA', 'GRELIDIEN', 'CADEVEN',
  'SEVIDE', 'ELOILLAN', 'BEODA',
  'VENDOGNUS', 'ABOEN', 'ALALIWEN',
  'GREG', 'BOZZA'
]
Product.destroy_all if Product.any?
Product.insert_all(
  products.map { |name| { name: name } }
)

Inventory.destroy_all if Inventory.any?
Store.all.each do |store|
  Product.all.each do |product|
    Inventory.create(store: store, product: product, quantity: 100)
  end
end
