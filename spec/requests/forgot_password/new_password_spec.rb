require 'rails_helper'

describe 'PATCH /new_password' do
  let!(:user) { create(:user, reset_password_code: 'QWERTY') }

  context 'VALID code' do
    let(:valid_params) do
      {
        forgot_password: {
          code: 'QWERTY',
          new_password: 'new_p4ssw0rd'
        }}
    end

    it 'returns 200' do
      patch '/new_password', params: valid_params
      expect(response.status).to eq 200
    end

    it 'sets new password' do
      expect {
        patch '/new_password', params: valid_params
      }.to change {
        user.reload.authenticate('new_p4ssw0rd')
      }.from false
    end

    it 'removes reset_password_code' do
      expect {
        patch '/new_password', params: valid_params
      }.to change {
        user.reload.reset_password_code
      }.to be_nil
    end
  end

  context 'INVALID new password' do
    it 'returns error message' do
      patch '/new_password', params: {
        forgot_password: { code: 'QWERTY', new_password: 'a' }
      }
      expect(json_response['errors']).to be_present
    end

    it 'does not change password' do
      expect {
        patch '/new_password', params: {
          forgot_password: { code: 'QWERTY', new_password: 'a' }
        }
      }.not_to change {
        user.reload.authenticate('a')
      }
    end
  end

  context 'INVALID code' do
    it 'returns 404' do
      patch '/new_password', params: {
        forgot_password: { code: '', new_password: 'new_p4ssw0rd' }
      }
      expect(response.status).to eq 404
    end
  end

end
