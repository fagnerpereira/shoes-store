class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  # creates a new webhook
  # enqueue the webhook to process it later
  def create
    # this line can be a problem if its not possible
    # to save the webhook for example because some data
    # is missing or databse is unavailable I would loss this data
    # 1 approach is if this line fails I enqueue in a job to perform later
    # 2 approach is put this inside a job and after saving, call ProcessJob
    webhook = Webhook.create!(payload: payload)
    store = Store.find_by!(name: webhook.payload['store'])
    product = Product.find_by!(name: webhook.payload['model'])
    inventory = Inventory.find_by!(store: store, product: product)
    Sale.create!(store: store, product: product, quantity: 1)
    inventory.update(quantity: webhook.payload['inventory'].to_i)

    # Webhooks::ProcessJob.perform_later(webhook)
    head :ok
  end

  private

  def payload
    params.slice(:store, :model, :inventory)
  end
end
