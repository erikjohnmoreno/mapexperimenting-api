class UserMailer < ApplicationMailer

  def welcome_email user
    data = {
      template_id: 'app-welcome-email',
      substitution_data: {
        email: user.email
      }
    }

    mail(to: user.email, sparkpost_data: data) do |format|
      format.text { render plain: 'OK' }
    end
  end

  def reset_pw_code user
    data = {
      template_id: 'app-forgot-password',
      substitution_data: {
        email: user.email,
        code: user.reset_password_code
      }
    }

    mail(to: user.email, sparkpost_data: data) do |format|
      format.text { render plain: 'OK' }
    end
  end
end
