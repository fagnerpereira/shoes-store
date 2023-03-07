module Stores
  class UpdateTotalSalesJob < ApplicationJob
    queue_as :default

    def perform(store)
      store.total_sales = store.sales.sum(:price)
      store.save
    end
  end
end
