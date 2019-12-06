require 'rails_helper'

describe 'POST /signup' do

  it 'returns 200 and creates new user' do
    expect {
      post '/signup', params: {
        user: {
          email: 'foo@gmail.com',
          password: '123456'
        }
      }

      expect(response.status).to eq 200
    }.to change { User.count }.by 1
  end

end
