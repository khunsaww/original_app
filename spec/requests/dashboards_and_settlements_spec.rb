require "rails_helper"

RSpec.describe "ダッシュボードと決算", type: :request do
  let!(:user) { create(:user) }
  let!(:warehouse) { create(:location, name: "第1倉庫") }
  let!(:factory) { create(:location, name: "工場A") }

  before do
    create(:die, name: "A", product_code: "A-1", location: warehouse, new_quantity: 7, used_quantity: 3, unit_price: 1000)
    create(:die, name: "B", product_code: "B-1", location: factory, new_quantity: 1, used_quantity: 4, unit_price: 2000)
    login_as(user)
  end

  describe "GET /" do
    it "在庫少の残数を新品・使用済みつきで表示する" do
      get root_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("ダッシュボード")
      expect(response.body).to include("残り5個")
      expect(response.body).to include("新品")
      expect(response.body).to include("使用済み")
    end
  end

  describe "GET /settlement" do
    it "総額と場所別の新品・使用済み金額を表示する" do
      get settlement_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("新品の在庫金額")
      expect(response.body).to include("使用済みの在庫金額")
      expect(response.body).to include("¥9,000")
      expect(response.body).to include("¥11,000")
      expect(response.body).to include("¥20,000")
      expect(response.body).to include("第1倉庫")
      expect(response.body).to include("工場A")
      expect(response.body).to include("2種類")
      expect(response.body).to include("新品金額")
      expect(response.body).to include("使用済み金額")
    end
  end
end
