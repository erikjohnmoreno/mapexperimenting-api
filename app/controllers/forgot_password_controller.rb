class ForgotPasswordController < ApplicationController
  skip_before_action :authenticate_request

  def forgot_password
    if obj = User.find_by_email(obj_params[:email])
      obj.update_column(:reset_password_code, generate_reset_code)
      UserMailer.reset_pw_code(obj).deliver! unless Rails.env.development?
    end

    render json: { success: true }
  end

  def verify_code
    if obj = User.find_by_reset_password_code(obj_params[:code])
      render json: { email: obj.email }
    else
      render json: {}, status: 404
    end
  end

  def new_password
    obj = User.find_by_reset_password_code(obj_params[:code])

    if obj && obj.update(password: obj_params[:new_password], reset_password_code: nil)
      render json: { success: true }
    elsif obj
      render_errors(obj)
    else
      render_not_found
    end
  end


  private

  def obj_params
    params.require(:forgot_password).permit(:email, :code, :new_password)
  end

  def generate_reset_code
    loop do
      code = SecureRandom.urlsafe_base64(5).upcase
      return code if not User.exists?(reset_password_code: code)
    end
  end

end
