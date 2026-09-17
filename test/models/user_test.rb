require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires unique email" do
    User.create!(build_user_attrs)
    dup = User.new(build_user_attrs(nickname: "別", email: "A@example.com"))
    assert_not dup.valid?
  end
end
