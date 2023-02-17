class DashboardController < ApplicationController
  FILTER_INTERVAL = {
    daily: 'group_by_day',
    weekly: 'group_by_week',
    monthly: 'group_by_month'
  }

  def index
    @sales = Sale.all
    @sales_by_stores = Sale.joins(:store).group('stores.name')
                                         .where(created_at: 7.days.ago..Time.current)
                                         .group_by_minute(:created_at)
                                         .count
  end

  def sales_by_stores
    @sales_by_stores = Sale.joins(:store)
                           .group('stores.name')
                           .where(created_at: filter_days.ago..Time.zone.now)
                           .send(FILTER_INTERVAL[filter_interval], :created_at)
                           .count
  end

  private

  def filter_days
    params[:filter_days].to_i.days
  end

  def filter_interval
    params[:filter_interval].to_sym
  end
end
