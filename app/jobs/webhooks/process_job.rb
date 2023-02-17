module Webhooks
  class ProcessJob < ApplicationJob
    queue_as :default

    def perform(webhook = nil)
      Webhook.where(status: :pending).limit(10).each do |webhook|
        webhook.process!
      end
    end
  end
end
