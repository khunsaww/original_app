class DiesController < ApplicationController
  before_action :require_admin, only: :destroy
  before_action :set_die, only: %i[show edit update destroy]
  before_action :load_locations, only: %i[index new create edit update]

  def index
    @search_params = search_params
    @dies = Die.search(@search_params)
    @result_count = @dies.count
    @result_new_quantity = @dies.sum(:new_quantity)
    @result_used_quantity = @dies.sum(:used_quantity)
    @result_quantity = @dies.sum(Arel.sql(Die::QUANTITY_SQL))
    @result_amount = @dies.sum(Arel.sql("#{Die::QUANTITY_SQL} * dies.unit_price"))
  end

  def show
    @quantity_changes = @die.quantity_changes.includes(:user).newest_first
  end

  def new
    @die = Die.new(new_quantity: 0, used_quantity: 0, unit_price: 0)
  end

  def create
    @die = Die.new(die_params)
    if @die.save
      redirect_to @die, notice: "ダイスを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @die.update(die_params)
      redirect_to @die, notice: "ダイスを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @die.destroy
    redirect_to dies_path, notice: "ダイスを削除しました", status: :see_other
  end

  private

  def set_die
    @die = Die.find(params[:id])
  end

  def load_locations
    @locations = Location.order(:name)
  end

  def die_params
    permitted = [
      :name, :product_code, :size, :category, :location_id,
      :new_quantity, :used_quantity, :purchase_date, :notes
    ]
    permitted << :unit_price if admin?
    params.require(:die).permit(*permitted)
  end

  def search_params
    params.permit(:name, :product_code, :category, :location_id)
  end
end
