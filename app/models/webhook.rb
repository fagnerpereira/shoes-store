class Webhook < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  scope :pending, -> { where(status: :pending) }
  scope :processed, -> { where(status: :processed) }

  validates :payload, presence: true

  enum status: {
    pending: 0,
    processed: 1,
    failed: 2
  }

  def process!
    log_around do
      transaction do
        Sale.create!(store:, product:, price: product.price)
        inventory.update!(quantity: payload['inventory'].to_i)
        processed!
        Webhooks::PurgeJob.perform_later(self)
      end
    end
  end

  private

  def log_around
    Rails.logger.info("[Webhook#process] started #{payload.inspect}")
    yield
    Rails.logger.info("[Webhook#process] completed #{payload.inspect}")
  rescue StandardError => e
    Rails.logger.error("[Webhook#process] failed #{payload.inspect} with #{e.message}")
  end

  def store
    @store ||= Store.find_by!(name: payload['store'])
  end

  def product
    @product ||= Product.find_by!(name: payload['model'])
  end

  def inventory
    @inventory ||= Inventory.find_by!(store:, product:)
  end

  def random_datetime(days = 100)
    (1..days).to_a.sample.days.ago - (1..1440).to_a.sample.minutes
  end
end
