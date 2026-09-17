class Location < ApplicationRecord
  has_many :dies, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true

  def stock_new_quantity
    dies.sum(:new_quantity)
  end

  def stock_used_quantity
    dies.sum(:used_quantity)
  end

  def stock_quantity
    dies.sum(Arel.sql(Die::QUANTITY_SQL))
  end

  def stock_amount
    dies.sum(Arel.sql("#{Die::QUANTITY_SQL} * dies.unit_price"))
  end
end
