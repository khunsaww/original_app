require "rails_helper"

RSpec.describe "ダイス", type: :request do
  let!(:user) { create(:user) }
  let!(:location) { create(:location, name: "第1倉庫") }

  before { login_as(user) }

  describe "GET /dies" do
    it "新品・使用済み列と検索結果を表示する" do
      create(:die, name: "ヘッダーダイス", product_code: "HD-01", location: location,
                   new_quantity: 2, used_quantity: 2, unit_price: 2500)

      get dies_path, params: { name: "ヘッダー", location_id: location.id }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("HD-01")
      expect(response.body).to include("在庫少")
      expect(response.body).to include("新品")
      expect(response.body).to include("使用済み")
    end
  end

  describe "POST /dies" do
    it "登録して詳細に合計金額と在庫少を出す" do
      login_as(create(:user, :admin, email: "price-admin@example.com"))

      expect {
        post dies_path, params: {
          die: {
            name: "ヘッダーダイス",
            product_code: "HD-01",
            size: "M6",
            category: "ヘッダーダイス",
            location_id: location.id,
            new_quantity: 2,
            used_quantity: 2,
            unit_price: 2500
          }
        }
      }.to change(Die, :count).by(1)

      die = Die.last
      expect(response).to redirect_to(die_path(die))
      follow_redirect!
      expect(response.body).to include("在庫少")
      expect(response.body).to include("¥10,000")
      expect(response.body).to include("新品")
      expect(response.body).to include("使用済み")
    end
  end

  describe "PATCH /dies/:id" do
    it "一般ユーザーは数量を更新できるが単価は変えられない" do
      die = create(:die, location: location, new_quantity: 10, used_quantity: 0, unit_price: 1000)

      patch die_path(die), params: { die: { new_quantity: 4, used_quantity: 1, unit_price: 9 } }

      expect(response).to redirect_to(die_path(die))
      die.reload
      expect(die.new_quantity).to eq(4)
      expect(die.used_quantity).to eq(1)
      expect(die.unit_price).to eq(1000)

      change = die.quantity_changes.last
      expect(change.new_quantity_before).to eq(10)
      expect(change.new_quantity_after).to eq(4)
      expect(change.used_quantity_before).to eq(0)
      expect(change.used_quantity_after).to eq(1)
      expect(change.user).to eq(user)

      get die_path(die)
      expect(response.body).to include("数量変更履歴")
      expect(response.body).to include("10 → 4")
    end
  end

  describe "DELETE /dies/:id" do
    it "一般ユーザーは削除できない" do
      die = create(:die, location: location)

      expect { delete die_path(die) }.not_to change(Die, :count)
      expect(response).to redirect_to(root_path)
    end

    it "管理者は削除できる" do
      login_as(create(:user, :admin, email: "del-admin@example.com"))
      die = create(:die, location: location)

      expect { delete die_path(die) }.to change(Die, :count).by(-1)
      expect(response).to redirect_to(dies_path)
    end
  end
end
