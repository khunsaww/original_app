require "test_helper"

class DiesFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(build_user_attrs(nickname: "管理者", email: "admin@example.com", role: :admin))
    @location = Location.create!(name: "第1倉庫")
    login_as(@user)
  end

  test "create show edit and search die" do
    post dies_path, params: {
      die: {
        name: "ヘッダーダイス",
        product_code: "HD-01",
        size: "M6",
        category: "ヘッダーダイス",
        location_id: @location.id,
        new_quantity: 2,
        used_quantity: 2,
        unit_price: 2500
      }
    }
    die = Die.last
    assert_redirected_to die_path(die)
    follow_redirect!
    assert_match "在庫少", response.body
    assert_match "¥10,000", response.body
    assert_match "新品", response.body
    assert_match "使用済み", response.body

    get dies_path, params: { name: "ヘッダー", location_id: @location.id }
    assert_response :success
    assert_match "HD-01", response.body
    assert_match "在庫少", response.body
  end
end
