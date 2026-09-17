class User < ApplicationRecord
  NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  KANA_REGEX = /\A[ァ-ヶー]+\z/

  alias_attribute :password_digest, :encrypted_password
  has_secure_password
  has_many :quantity_changes, dependent: :nullify

  enum :role, { general: 0, admin: 1 }, default: :general, validate: true

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nickname, presence: true
  validates :last_name, :first_name, presence: true, format: { with: NAME_REGEX, message: "は全角で入力してください" }
  validates :last_name_kana, :first_name_kana, presence: true, format: { with: KANA_REGEX, message: "は全角カタカナで入力してください" }
  validates :birthday, presence: true
  validates :password, length: { minimum: 8 }, allow_nil: true
  validate :keep_at_least_one_admin, on: :update

  before_destroy :prevent_destroying_last_admin

  def role_label
    general? ? "一般" : "管理者"
  end

  def full_name
    "#{last_name} #{first_name}"
  end

  def display_name
    nickname
  end

  private

  def keep_at_least_one_admin
    return unless will_save_change_to_role? && general? && last_admin?

    errors.add(:role, "は最後の管理者を一般に変更できません")
  end

  def prevent_destroying_last_admin
    return unless admin? && last_admin?

    errors.add(:base, "最後の管理者は削除できません")
    throw :abort
  end

  def last_admin?
    self.class.admin.where.not(id: id).none?
  end
end
