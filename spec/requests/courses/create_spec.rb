require 'rails_helper'

describe 'POST /api/courses' do
  let!(:user) { create(:user, password: '123123123')}

  def valid_params
    {
      resource: {
        start_lat: 234234,
        start_lng: 234234,
        end_lat: 234234,
        end_lng: 123234234,
        name: "cool"
      }
    }
  end

  it 'create a course' do
    auth_post '/api/courses', valid_params
    expect(json_response["user_id"] == user.id).to eql true
  end
end
