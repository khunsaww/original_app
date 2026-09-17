require "test_helper"

class DieTest < ActiveSupport::TestCase
  setup do
    @location = Location.create!(name: "第1倉庫")
  end

  test "total_amount is new amount plus used amount" do
    die = Die.new(name: "A", product_code: "A-1", location: @location, new_quantity: 7, used_quantity: 3, unit_price: 1500)
    assert_equal 10, die.quantity
    assert_equal 10_500, die.new_amount
    assert_equal 4_500, die.used_amount
    assert_equal 15_000, die.total_amount
  end

  test "low_stock when combined quantity is 5 or less" do
    die = Die.new(name: "A", product_code: "A-1", location: @location, new_quantity: 2, used_quantity: 3, unit_price: 1)
    assert die.low_stock?

    die.new_quantity = 3
    assert_not die.low_stock?
  end

  test "rejects negative new or used quantity" do
    die = Die.new(name: "A", product_code: "A-1", location: @location, new_quantity: -1, used_quantity: 0, unit_price: 0)
    assert_not die.valid?
    assert_includes die.errors[:new_quantity], "は0以上の値にしてください"

    die = Die.new(name: "A", product_code: "A-1", location: @location, new_quantity: 0, used_quantity: -1, unit_price: 0)
    assert_not die.valid?
    assert_includes die.errors[:used_quantity], "は0以上の値にしてください"
  end

  test "search filters by name product_code category and location" do
    other = Location.create!(name: "工場A")
    match = Die.create!(name: "ヘッダーダイス M6", product_code: "HD-M6", category: "ヘッダーダイス", location: @location, new_quantity: 3, used_quantity: 0, unit_price: 100)
    Die.create!(name: "転造ダイス M8", product_code: "RD-M8", category: "転造ダイス", location: other, new_quantity: 10, used_quantity: 0, unit_price: 200)

    results = Die.search(name: "ヘッダー", product_code: "HD", category: "ヘッダー", location_id: @location.id)
    assert_equal [match], results.to_a
  end

  test "total_amount_sum aggregates all dies" do
    Die.create!(name: "A", product_code: "A-1", location: @location, new_quantity: 1, used_quantity: 1, unit_price: 1000)
    Die.create!(name: "B", product_code: "B-1", location: @location, new_quantity: 2, used_quantity: 1, unit_price: 2000)
    assert_equal 8000, Die.total_amount_sum
    assert_equal 5000, Die.total_new_amount_sum
    assert_equal 3000, Die.total_used_amount_sum
    assert_equal 5, Die.total_quantity
    assert_equal 3, Die.total_new_quantity
    assert_equal 2, Die.total_used_quantity
    assert_equal 2, Die.kind_count
  end
end
