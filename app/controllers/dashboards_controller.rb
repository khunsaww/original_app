class DashboardsController < ApplicationController
  def show
    @kind_count = Die.kind_count
    @total_new_quantity = Die.total_new_quantity
    @total_used_quantity = Die.total_used_quantity
    @total_quantity = Die.total_quantity
    @total_amount = Die.total_amount_sum
    @low_stock_dies = Die.low_stock.includes(:location)
  end
end
