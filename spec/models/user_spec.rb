require "rails_helper"

RSpec.describe User, type: :model do
  it "メールアドレスは小文字化して一意" do
    create(:user, email: "a@example.com")
    dup = build(:user, email: "A@example.com")

    expect(dup).not_to be_valid
    expect(dup.errors[:email]).to include("はすでに存在します")
  end

  it "パスワードは8文字以上" do
    user = build(:user, password: "short")

    expect(user).not_to be_valid
    expect(user.errors[:password]).to include("は8文字以上で入力してください")
  end

  it "姓名は全角、カナは全角カタカナ" do
    user = build(:user, last_name: "Yamada", first_name_kana: "たろう")

    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("は全角で入力してください")
    expect(user.errors[:first_name_kana]).to include("は全角カタカナで入力してください")
  end

  it "既定の権限は一般" do
    expect(build(:user)).to be_general
  end

  it "最後の管理者は一般に変更できない" do
    admin = create(:user, :admin)
    admin.role = :general

    expect(admin).not_to be_valid
    expect(admin.errors[:role]).to include("は最後の管理者を一般に変更できません")
  end

  it "最後の管理者は削除できない" do
    admin = create(:user, :admin)

    expect(admin.destroy).to be_falsey
    expect(User).to exist(admin.id)
  end
end
