Rails.application.routes.draw do
  post :signup, to: 'registration#create'
  post :signin, to: 'authentication#sign_in'

  post :forgot_password, to: 'forgot_password#forgot_password'
  get :verify_code, to: 'forgot_password#verify_code'
  patch :new_password, to: 'forgot_password#new_password'

  api vendor_string: "mapexperimenting-api", default_version: 1 do
    version 1 do
      cache as: 'v1' do
        resources :courses
      end
    end
  end
end
