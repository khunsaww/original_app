class Die < ApplicationRecord
  LOW_STOCK_THRESHOLD = 5
  QUANTITY_SQL = "(COALESCE(dies.new_quantity, 0) + COALESCE(dies.used_quantity, 0))"
  NEW_AMOUNT_SQL = "(COALESCE(dies.new_quantity, 0) * COALESCE(dies.unit_price, 0))"
  USED_AMOUNT_SQL = "(COALESCE(dies.used_quantity, 0) * COALESCE(dies.unit_price, 0))"
  AMOUNT_SQL = "(#{NEW_AMOUNT_SQL} + #{USED_AMOUNT_SQL})"

  belongs_to :location
  has_many :quantity_changes, dependent: :delete_all

  validates :name, presence: true
  validates :product_code, presence: true
  validates :new_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :used_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :unit_price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_update :record_quantity_change, if: :quantity_changed?

  scope :low_stock, -> {
    where("#{QUANTITY_SQL} <= ?", LOW_STOCK_THRESHOLD).order(Arel.sql("#{QUANTITY_SQL} ASC"), :id)
  }
  scope :ordered, -> { order(:id) }

  def quantity
    new_quantity.to_i + used_quantity.to_i
  end

  def new_amount
    new_quantity.to_i * unit_price.to_i
  end

  def used_amount
    used_quantity.to_i * unit_price.to_i
  end

  def total_amount
    new_amount + used_amount
  end

  def low_stock?
    quantity <= LOW_STOCK_THRESHOLD
  end

  def self.search(params)
    rel = includes(:location)
    rel = rel.where("dies.name LIKE ?", "%#{sanitize_sql_like(params[:name].to_s)}%") if params[:name].present?
    if params[:product_code].present?
      rel = rel.where("dies.product_code LIKE ?", "%#{sanitize_sql_like(params[:product_code].to_s)}%")
    end
    if params[:category].present?
      rel = rel.where("dies.category LIKE ?", "%#{sanitize_sql_like(params[:category].to_s)}%")
    end
    rel = rel.where(location_id: params[:location_id]) if params[:location_id].present?
    rel.ordered
  end

  def self.kind_count
    count
  end

  def self.total_quantity
    sum(Arel.sql(QUANTITY_SQL))
  end

  def self.total_new_quantity
    sum(:new_quantity)
  end

  def self.total_used_quantity
    sum(:used_quantity)
  end

  def self.total_new_amount_sum
    sum(Arel.sql(NEW_AMOUNT_SQL))
  end

  def self.total_used_amount_sum
    sum(Arel.sql(USED_AMOUNT_SQL))
  end

  def self.total_amount_sum
    sum(Arel.sql(AMOUNT_SQL))
  end

  def self.totals_by_location
    joins(:location)
      .group("locations.id", "locations.name")
      .order("locations.name")
      .pluck(
        Arel.sql("locations.id"),
        Arel.sql("locations.name"),
        Arel.sql("SUM(dies.new_quantity)"),
        Arel.sql("SUM(dies.used_quantity)"),
        Arel.sql("SUM#{QUANTITY_SQL}"),
        Arel.sql("SUM#{NEW_AMOUNT_SQL}"),
        Arel.sql("SUM#{USED_AMOUNT_SQL}"),
        Arel.sql("SUM#{AMOUNT_SQL}")
      )
  end

  private

  def quantity_changed?
    saved_change_to_new_quantity? || saved_change_to_used_quantity?
  end

  def record_quantity_change
    quantity_changes.create!(
      user: Current.user,
      new_quantity_before: saved_change_to_new_quantity&.first || new_quantity,
      new_quantity_after: new_quantity,
      used_quantity_before: saved_change_to_used_quantity&.first || used_quantity,
      used_quantity_after: used_quantity
    )
  end

  # マイグレーション直後、起動中の開発サーバーが古い列情報のままになるのを防ぐ
  reset_column_information if Rails.env.development?
end
