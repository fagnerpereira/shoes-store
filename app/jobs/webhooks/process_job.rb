module Webhooks
  class ProcessJob < ApplicationJob
    queue_as :default

    def perform
      Webhook.where(status: :pending).each(&:process!)
    end
  end
end
