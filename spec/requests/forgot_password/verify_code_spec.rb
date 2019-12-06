require 'rails_helper'

describe 'GET /verify_code' do
  let!(:user) { create(:user, reset_password_code: 'QWERTY') }

  it 'returns 200 status for EXISTING code' do
    get '/verify_code?forgot_password[code]=QWERTY'
    expect(response.status).to eq 200
  end

  it 'returns 404 status for NON-EXISTING code' do
    get '/verify_code?forgot_password[code]=ASDFGH'
    expect(response.status).to eq 404
  end

end
