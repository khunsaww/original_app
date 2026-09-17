require "rails_helper"

RSpec.describe "保管場所", type: :request do
  let!(:location) { create(:location, name: "工場A") }

  describe "管理者" do
    let!(:user) { create(:user, :admin) }

    before { login_as(user) }

    it "登録できる" do
      expect {
        post locations_path, params: { location: { name: "第1倉庫", description: "本社横" } }
      }.to change(Location, :count).by(1)

      expect(response).to redirect_to(location_path(Location.last))
    end

    it "ダイスがある保管場所は削除できない" do
      create(:die, location: location)

      expect { delete location_path(location) }.not_to change(Location, :count)
      expect(response).to redirect_to(location_path(location))
      follow_redirect!
      expect(response.body).to include("ダイスが登録されている保管場所は削除できません")
    end

    it "空の保管場所は削除できる" do
      empty = create(:location, name: "空倉庫")

      expect { delete location_path(empty) }.to change(Location, :count).by(-1)
      expect(response).to redirect_to(locations_path)
    end
  end

  describe "一般ユーザー" do
    let!(:user) { create(:user) }

    before { login_as(user) }

    it "一覧と詳細は見られる" do
      create(:die, name: "転造ダイス", product_code: "RD-01", location: location,
                   new_quantity: 5, used_quantity: 2, unit_price: 1000)

      get locations_path
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include("新規登録")

      get location_path(location)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("転造ダイス")
      expect(response.body).not_to include("新規登録")
    end

    it "登録できない" do
      expect {
        post locations_path, params: { location: { name: "第1倉庫", description: "本社横" } }
      }.not_to change(Location, :count)
      expect(response).to redirect_to(root_path)
    end
  end
end
