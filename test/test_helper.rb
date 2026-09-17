ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActionDispatch::IntegrationTest
  def login_as(user, password: "password")
    post login_path, params: { email: user.email, password: password }
    follow_redirect! if response.redirect?
  end
end

module UserTestHelper
  def build_user_attrs(overrides = {})
    {
      nickname: "テスト",
      email: "a@example.com",
      password: "password",
      last_name: "山田",
      first_name: "太郎",
      last_name_kana: "ヤマダ",
      first_name_kana: "タロウ",
      birthday: Date.new(1990, 1, 1)
    }.merge(overrides)
  end
end

module ActiveSupport
  class TestCase
    include UserTestHelper
    parallelize(workers: 1)
  end
end
