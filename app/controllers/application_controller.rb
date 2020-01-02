class ApplicationController < ActionController::API
  include CommonActions

  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    header = header.split.last if header
    
    begin
      raise JWT::DecodeError unless @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Bad request' }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { error: 'Session expired' }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
