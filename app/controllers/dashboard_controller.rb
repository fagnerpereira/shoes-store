class DashboardController < ApplicationController
  def index
    @sales = Sale.all
  end
end
