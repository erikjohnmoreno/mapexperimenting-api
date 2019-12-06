require 'rails_helper'

describe 'POST /forgot_password' do
  let!(:user) { create(:user, email: 'test@sp.com') }

  context 'EXISTING email' do
    it 'returns 200 status' do
      post '/forgot_password', params: { forgot_password: { email: 'test@sp.com' } }
      expect(response.status).to eq 200
    end

    it 'generates reset_password_code' do
      expect {
        post '/forgot_password', params: { forgot_password: { email: 'test@sp.com' } }
      }.to change {
        user.reload.reset_password_code
      }
    end
  end

  context 'NON-EXISTING email' do
    it 'returns 200 status' do
      post '/forgot_password', params: { forgot_password: { email: '' } }
      expect(response.status).to eq 200
    end
  end

end
