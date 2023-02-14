# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
PRODUCTS = [
  'ADERI', 'MIRIRA', 'CAELAN',
  'BUTAUD', 'SCHOOLER', 'SODANO',
  'MCTYRE', 'CADAUDIA', 'RASIEN',
  'WUMA', 'GRELIDIEN', 'CADEVEN',
  'SEVIDE', 'ELOILLAN', 'BEODA',
  'VENDOGNUS', 'ABOEN', 'ALALIWEN',
  'GREG', 'BOZZA'
].freeze
STORES = [
  'ALDO Centre Eaton', 'ALDO Destiny USA Mall',
  'ALDO Pheasant Lane Mall', 'ALDO Holyoke Mall',
  'ALDO Maine Mall', 'ALDO Crossgates Mall',
  'ALDO Burlington Mall', 'ALDO Solomon Pond Mall',
  'ALDO Auburn Mall', 'ALDO Waterloo Premium Outlets'
].freeze
PRICES = (30.50..119.99).step(2.7).to_a

Store.transaction do
  Sale.destroy_all if Sale.any?
  Inventory.destroy_all if Inventory.any?
  Product.destroy_all if Product.any?
  Store.destroy_all if Store.any?

  Store.insert_all(
    STORES.map { |name| { name: name } }
  )

  Product.insert_all(
    PRODUCTS.map do |name|
      { name: name, price: PRICES.sample.round(2) }
    end
  )

  Store.all.each do |store|
    Product.all.each do |product|
      Inventory.create(store: store, product: product, quantity: 150)
    end
  end

  store = Store.first
  product = Product.first
  Sale.create(
    store:,
    product:,
    data: {
      store: { id: store.id, name: store.name },
      product: { id: product.id, name: product.name, price: product.price }
    }
  )
  Sale.create(
    store:,
    product:,
    data: {
      store: { id: store.id, name: store.name },
      product: { id: product.id, name: product.name, price: product.price }
    }
  )
end
# stores = Store.all
# products = Product.all
# year = 2023
# months = [1]
# days = (1..30).to_a
#
# Sale.create(
#   store: stores.first(5).sample,
#   product: products.sample,
#   quantity: (1..15).to_a.sample,
#   created_at: "#{year}-#{months.sample}-#{days.sample}"
# )
