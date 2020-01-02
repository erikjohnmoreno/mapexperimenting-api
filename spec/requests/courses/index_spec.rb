require 'rails_helper'

describe 'GET /api/courses' do
  let!(:user) { create(:user, password: '123123123123')}
  let!(:course) { create(:course, user: user)}

  it 'return all courses of current user' do
    auth_get '/api/courses'
    expect(json_response.count > 0).to eql true
  end

end
