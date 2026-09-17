require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#yen" do
    it "円記号つきで整数表示する" do
      expect(helper.yen(1_000_000)).to eq("¥1,000,000")
    end
  end

  describe "#quantity_counts" do
    it "新品・使用済み・計を並べる" do
      expect(helper.quantity_counts(90, 30, 120)).to eq("新品 90 / 使用済み 30 / 計 120")
    end
  end

  describe "#signed_number" do
    it "増減の符号を付ける" do
      expect(helper.signed_number(3)).to eq("+3")
      expect(helper.signed_number(-2)).to eq("-2")
      expect(helper.signed_number(0)).to eq("0")
    end
  end
end
