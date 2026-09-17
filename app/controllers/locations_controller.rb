class LocationsController < ApplicationController
  before_action :require_admin, only: %i[new create edit update destroy]
  before_action :set_location, only: %i[show edit update destroy]

  def index
    @locations = Location.order(:name)
    @die_counts = Die.group(:location_id).count
  end

  def show
    @dies = @location.dies.ordered
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to @location, notice: "保管場所を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to @location, notice: "保管場所を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @location.destroy
      redirect_to locations_path, notice: "保管場所を削除しました", status: :see_other
    else
      redirect_to @location, alert: "ダイスが登録されている保管場所は削除できません", status: :see_other
    end
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :description)
  end
end
