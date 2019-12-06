class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def sign_in
    obj = User.find_by_email(obj_params[:email])

    if obj && obj.authenticate(obj_params[:password])
      render json: {
        data: {
          email: obj.email,
          auth_token: JsonWebToken::encode(user_id: obj.id),
        }}
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end


  private


  def obj_params
    params.require(:credentials).permit(:email, :password)
  end
end
