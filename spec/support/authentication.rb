module AuthenticationHelpers
  def login_as(user, password: "password")
    post login_path, params: { email: user.email, password: password }
    follow_redirect! if response.redirect?
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
