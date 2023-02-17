class DashboardController < ApplicationController
  def index
    @sales = Sale.all
    @sales_by_stores = Sale.joins(:store).group('stores.name').where(created_at: 7.days.ago..Time.current)
  end

  def sales_by_stores
    @sales_by_stores = Sale.joins(:store)
                           .group('stores.name')
                           .where(created_at: days_to_filter.ago..Time.zone.now)
  end

  private

  def days_to_filter
    params[:days_to_filter].to_i.days
  end
end
