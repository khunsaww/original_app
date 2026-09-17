require "rails_helper"

RSpec.describe "ユーザー管理", type: :request do
  let!(:admin) { create(:user, :admin, email: "admin@example.com") }

  describe "管理者" do
    before { login_as(admin) }

    it "一覧を表示できる" do
      get users_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("ユーザー一覧")
    end

    it "一般ユーザーを登録できる" do
      expect {
        post users_path, params: {
          user: {
            nickname: "現場A",
            email: "staff@example.com",
            password: "password",
            last_name: "佐藤",
            first_name: "次郎",
            last_name_kana: "サトウ",
            first_name_kana: "ジロウ",
            birthday: "1991-02-03",
            role: "general"
          }
        }
      }.to change(User, :count).by(1)

      expect(User.last).to be_general
      expect(response).to redirect_to(user_path(User.last))
    end

    it "一般ユーザーを削除できる" do
      staff = create(:user, email: "staff@example.com")

      expect { delete user_path(staff) }.to change(User, :count).by(-1)
      expect(response).to redirect_to(users_path)
    end
  end

  describe "一般ユーザー" do
    let!(:staff) { create(:user, email: "staff@example.com") }

    before { login_as(staff) }

    it "ユーザー管理にアクセスできない" do
      get users_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("この操作は管理者のみ実行できます")
    end

    it "ナビにユーザー管理が出ない" do
      get root_path
      expect(response.body).not_to include('href="/users"')
    end
  end
end
