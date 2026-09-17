require "rails_helper"

RSpec.describe "認証", type: :request do
  let!(:user) { create(:user, email: "admin@example.com", password: "password") }

  it "未ログインはログイン画面へ送る" do
    get root_path
    expect(response).to redirect_to(login_path)
  end

  it "正しいパスワードでログインしダッシュボードを表示する" do
    post login_path, params: { email: "admin@example.com", password: "password" }

    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response).to have_http_status(:success)
    expect(response.body).to include("ダッシュボード")
  end

  it "誤ったパスワードではログインできない" do
    post login_path, params: { email: "admin@example.com", password: "wrong" }

    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "ログアウトできる" do
    login_as(user)
    delete logout_path

    expect(response).to redirect_to(login_path)
    get root_path
    expect(response).to redirect_to(login_path)
  end
end
