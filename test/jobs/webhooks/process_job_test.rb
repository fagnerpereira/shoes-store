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
      assert_difference('Sale.count') do
        Webhooks::ProcessJob.perform_now(@webhook)
      end
      assert_not_nil(created_sale)
      assert_equal(@inventory.reload.quantity, webhook_params['inventory'])
      assert(@webhook.reload.processed?)
    end

    private

    def created_sale
      Sale.find_by(
        store: @store,
        product: @product,
        quantity: 1
      )
    end

    def webhook_params
      {
        'store' => @store.name,
        'model' => @product.name,
        'inventory' => 60
      }
    end
  end
end
