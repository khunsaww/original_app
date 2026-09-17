class SettlementsController < ApplicationController
  def show
    @kind_count = Die.kind_count
    @total_new_quantity = Die.total_new_quantity
    @total_used_quantity = Die.total_used_quantity
    @total_quantity = Die.total_quantity
    @total_new_amount = Die.total_new_amount_sum
    @total_used_amount = Die.total_used_amount_sum
    @total_amount = Die.total_amount_sum
    @location_totals = Die.totals_by_location
  end
end
