def current_user
  @current_user ||= User.first || FactoryBot.create(:user, password: '123123123')
end
