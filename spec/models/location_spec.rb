require "rails_helper"

RSpec.describe Location, type: :model do
  describe "validations" do
    it "名称は一意" do
      create(:location, name: "第1倉庫")
      dup = build(:location, name: "第1倉庫")

      expect(dup).not_to be_valid
      expect(dup.errors[:name]).to include("はすでに存在します")
    end
  end

  describe "destroy" do
    it "ダイスがある保管場所は削除できない" do
      location = create(:location, name: "棚A-01")
      create(:die, location: location)

      expect(location.destroy).to be_falsey
      expect(Location).to exist(location.id)
    end

    it "空の保管場所は削除できる" do
      location = create(:location, name: "空倉庫")

      expect(location.destroy).to be_truthy
      expect(Location).not_to exist(location.id)
    end
  end

  describe "在庫集計" do
    it "新品・使用済み・金額を場所単位で合計する" do
      location = create(:location)
      create(:die, location: location, new_quantity: 2, used_quantity: 3, unit_price: 1000)
      create(:die, location: location, new_quantity: 1, used_quantity: 1, unit_price: 500)

      expect(location.stock_new_quantity).to eq(3)
      expect(location.stock_used_quantity).to eq(4)
      expect(location.stock_quantity).to eq(7)
      expect(location.stock_amount).to eq(6000)
    end
  end
end
