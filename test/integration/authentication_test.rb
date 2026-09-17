require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(build_user_attrs(nickname: "管理者", email: "admin@example.com"))
  end

  test "guests are redirected to login" do
    get root_path
    assert_redirected_to login_path
  end

  test "login and dashboard" do
    post login_path, params: { email: "admin@example.com", password: "password" }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_select "h1", "ダッシュボード"
  end

  test "invalid login" do
    post login_path, params: { email: "admin@example.com", password: "wrong" }
    assert_response :unprocessable_entity
  end
end
