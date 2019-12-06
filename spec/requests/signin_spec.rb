require 'rails_helper'

describe 'POST /authenticate' do

  let(:user) { create(:user, password: '123123123') }

  it 'returns 200 status & auth_token for valid creds' do
    post '/signin', params: {
      credentials: {
        email: user.email, password: '123123123'
      }
    }

    expect(response.status).to eq 200
    expect(json_response['data']).to include 'auth_token'
  end

  it 'returns 401 status for invalid creds' do
    post '/signin', params: {
      credentials: {
        email: user.email, password: 'wrongpassword'
      }
    }

    expect(response.status).to eq 401
    expect(json_response).to include 'error'
  end

end
