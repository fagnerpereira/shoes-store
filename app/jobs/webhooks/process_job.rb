module Webhooks
  class ProcessJob < ApplicationJob
    queue_as :default

    def perform(webhook)
      year = 2022
      months = (6..12).to_a
      days = (1..31).to_a
      store = Store.find_by!(name: webhook.payload['store'])
      product = Product.find_by!(name: webhook.payload['model'])
      inventory = Inventory.find_by!(store:, product:)
      Sale.create!(
        store:,
        product:,
        quantity: 1,
        created_at: "#{year}-#{months.sample}-#{days.sample}"
      )
      inventory.update!(quantity: webhook.payload['inventory'].to_i)
      webhook.processed!
      webhook.destroy!
    end
  end
end
