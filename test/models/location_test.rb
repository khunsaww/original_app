require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "cannot destroy location that has dies" do
    location = Location.create!(name: "棚A-01")
    Die.create!(name: "A", product_code: "A-1", location: location, new_quantity: 1, used_quantity: 0, unit_price: 100)

    assert_not location.destroy
    assert Location.exists?(location.id)
  end

  test "can destroy empty location" do
    location = Location.create!(name: "空倉庫")
    assert location.destroy
  end
end
