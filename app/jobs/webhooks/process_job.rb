module Webhooks
  class ProcessJob < ApplicationJob
    queue_as :default

    def perform(webhook)
      webhook.process!
    end
  end
end
