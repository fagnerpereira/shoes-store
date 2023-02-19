require 'test_helper'

module Webhooks
  class CreateJobTest < ActiveJob::TestCase
    setup do
      @args = {
        'store' => 'store_name',
        'model' => 'product_name',
        'inventory' => '99'
      }
    end

    test 'create a webhook' do
      assert_difference('Webhook.count') do
        Webhooks::CreateJob.perform_now(@args)
      end

      created_webhook = Webhook.first
      assert created_webhook.pending?
      assert_equal @args, created_webhook.payload
    end
  end
end
