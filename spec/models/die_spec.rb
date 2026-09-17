require "rails_helper"

RSpec.describe Die, type: :model do
  let(:location) { create(:location, name: "第1倉庫") }

  describe "#quantity / #new_amount / #used_amount / #total_amount" do
    it "新品と使用済みの金額を別々に出し、合計は両者の和にする" do
      die = build(:die, location: location, new_quantity: 7, used_quantity: 3, unit_price: 1500)

      expect(die.quantity).to eq(10)
      expect(die.new_amount).to eq(10_500)
      expect(die.used_amount).to eq(4_500)
      expect(die.total_amount).to eq(15_000)
    end
  end

  describe "#low_stock?" do
    it "合計数量が5以下なら在庫少" do
      die = build(:die, location: location, new_quantity: 2, used_quantity: 3, unit_price: 1)

      expect(die).to be_low_stock

      die.new_quantity = 3
      expect(die).not_to be_low_stock
    end
  end

  describe "validations" do
    it "新品・使用済みが負数なら無効" do
      die = build(:die, location: location, new_quantity: -1, used_quantity: 0, unit_price: 0)
      expect(die).not_to be_valid
      expect(die.errors[:new_quantity]).to include("は0以上の値にしてください")

      die = build(:die, location: location, new_quantity: 0, used_quantity: -1, unit_price: 0)
      expect(die).not_to be_valid
      expect(die.errors[:used_quantity]).to include("は0以上の値にしてください")
    end

    it "ダイス名と型番は必須" do
      die = build(:die, location: location, name: "", product_code: "")
      expect(die).not_to be_valid
      expect(die.errors[:name]).to be_present
      expect(die.errors[:product_code]).to be_present
    end
  end

  describe ".search" do
    it "ダイス名・型番・種類・保管場所で絞り込む" do
      other = create(:location, name: "工場A")
      match = create(:die, name: "ヘッダーダイス M6", product_code: "HD-M6", category: "ヘッダーダイス",
                           location: location, new_quantity: 3, used_quantity: 0, unit_price: 100)
      create(:die, name: "転造ダイス M8", product_code: "RD-M8", category: "転造ダイス",
                   location: other, new_quantity: 10, used_quantity: 0, unit_price: 200)

      results = described_class.search(name: "ヘッダー", product_code: "HD", category: "ヘッダー", location_id: location.id)

      expect(results.to_a).to eq([match])
    end
  end

  describe "集計" do
    before do
      create(:die, name: "A", product_code: "A-1", location: location, new_quantity: 1, used_quantity: 1, unit_price: 1000)
      create(:die, name: "B", product_code: "B-1", location: location, new_quantity: 2, used_quantity: 1, unit_price: 2000)
    end

    it "全ダイスの数量と金額を合計する" do
      expect(described_class.total_amount_sum).to eq(8000)
      expect(described_class.total_new_amount_sum).to eq(5000)
      expect(described_class.total_used_amount_sum).to eq(3000)
      expect(described_class.total_quantity).to eq(5)
      expect(described_class.total_new_quantity).to eq(3)
      expect(described_class.total_used_quantity).to eq(2)
      expect(described_class.kind_count).to eq(2)
    end
  end

  describe ".totals_by_location" do
    it "保管場所ごとに新品・使用済みの数量と金額を返す" do
      factory = create(:location, name: "工場A")
      create(:die, name: "A", product_code: "A-1", location: location, new_quantity: 7, used_quantity: 3, unit_price: 1000)
      create(:die, name: "B", product_code: "B-1", location: factory, new_quantity: 1, used_quantity: 4, unit_price: 2000)

      rows = described_class.totals_by_location
      by_name = rows.to_h { |id, name, new_qty, used_qty, total, new_amount, used_amount, amount|
        [name, [id, new_qty, used_qty, total, new_amount, used_amount, amount]]
      }

      expect(by_name["工場A"][1..]).to eq([1, 4, 5, 2_000, 8_000, 10_000])
      expect(by_name["第1倉庫"][1..]).to eq([7, 3, 10, 7_000, 3_000, 10_000])
    end
  end

  describe "数量変更履歴" do
    it "数量変更の履歴を残し、数量以外では残さない" do
      die = create(:die, location: location, new_quantity: 10, used_quantity: 0)
      Current.user = create(:user)

      expect {
        die.update!(new_quantity: 7, used_quantity: 2)
      }.to change(QuantityChange, :count).by(1)

      change = die.quantity_changes.last
      expect(change.new_quantity_before).to eq(10)
      expect(change.new_quantity_after).to eq(7)
      expect(change.used_quantity_before).to eq(0)
      expect(change.used_quantity_after).to eq(2)
      expect(change.user).to eq(Current.user)

      expect {
        die.update!(notes: "メモのみ")
      }.not_to change(QuantityChange, :count)
    ensure
      Current.reset
    end
  end
end
