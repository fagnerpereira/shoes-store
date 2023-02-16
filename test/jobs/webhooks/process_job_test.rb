require 'test_helper'

module Webhooks
  class ProcessJobTest < ActiveJob::TestCase
    setup do
      @store = stores(:store_a)
      @product = products(:product_a)
      @inventory = Inventory.create(store: @store, product: @product, quantity: 100)
      @webhook = Webhook.create(payload: webhook_params)
    end

    test 'process a webhook' do
      assert_difference -> { Sale.count } => 1, -> { Webhook.count } => -1 do
        Webhooks::ProcessJob.perform_now(@webhook)
      end
      assert_equal(@inventory.reload.quantity, webhook_params['inventory'])
    end

    private

    def webhook_params
      {
        'store' => @store.name,
        'model' => @product.name,
        'inventory' => 60
      }
    end
  end
end
