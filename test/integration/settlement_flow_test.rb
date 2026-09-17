require "test_helper"

class SettlementFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(build_user_attrs(nickname: "管理者", email: "admin@example.com"))
    warehouse = Location.create!(name: "第1倉庫")
    factory = Location.create!(name: "工場A")
    Die.create!(name: "A", product_code: "A-1", location: warehouse, new_quantity: 7, used_quantity: 3, unit_price: 1000)
    Die.create!(name: "B", product_code: "B-1", location: factory, new_quantity: 1, used_quantity: 4, unit_price: 2000)
    login_as(@user)
  end

  test "settlement page shows grand total and per location totals" do
    get settlement_path
    assert_response :success
    assert_match "¥9,000", response.body
    assert_match "¥11,000", response.body
    assert_match "¥20,000", response.body
    assert_match "第1倉庫", response.body
    assert_match "工場A", response.body
    assert_match "2種類", response.body
    assert_match "新品", response.body
    assert_match "使用済み", response.body
  end

  test "dashboard shows low stock" do
    get root_path
    assert_response :success
    assert_match "残り5個", response.body
  end
end
