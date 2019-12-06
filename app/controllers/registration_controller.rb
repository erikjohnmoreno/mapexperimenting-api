class RegistrationController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  after_action :send_welcome_email, only: :create, if: -> { @obj.id && !Rails.env.development? }

  private

  def resource
    User
  end

  def obj_params
    params.require(:user).permit(
      :email,
      :password
    )
  end

  def send_welcome_email
    UserMailer.welcome_email(@obj).deliver
  end
  
end
