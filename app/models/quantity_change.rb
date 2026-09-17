class QuantityChange < ApplicationRecord
  belongs_to :die
  belongs_to :user, optional: true

  validates :new_quantity_before, :new_quantity_after,
            :used_quantity_before, :used_quantity_after,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :newest_first, -> { order(created_at: :desc, id: :desc) }

  def actor_name
    user&.display_name.presence || "（不明）"
  end

  def new_quantity_delta
    new_quantity_after - new_quantity_before
  end

  def used_quantity_delta
    used_quantity_after - used_quantity_before
  end
end
