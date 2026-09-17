require "rails_helper"

RSpec.describe "ユーザー登録", type: :request do
  let(:valid_params) do
    {
      user: {
        nickname: "現場B",
        email: "new@example.com",
        password: "password",
        password_confirmation: "password",
        last_name: "鈴木",
        first_name: "一郎",
        last_name_kana: "スズキ",
        first_name_kana: "イチロウ",
        birthday: "1988-07-07"
      }
    }
  end

  it "必要項目を入れて一般ユーザーとして登録しログインする" do
    expect { post signup_path, params: valid_params }.to change(User, :count).by(1)

    user = User.last
    expect(user).to be_general
    expect(user.nickname).to eq("現場B")
    expect(user.last_name).to eq("鈴木")
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("ダッシュボード")
    expect(response.body).to include("現場B")
  end

  it "不正なカナでは登録できない" do
    params = valid_params
    params[:user][:last_name_kana] = "suzuki"

    expect { post signup_path, params: params }.not_to change(User, :count)
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
