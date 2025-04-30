# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request
  
  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last

    @current_user = decode(token) if token.present?

    render json: { errors: ['Not Authorized'] }, status: :unauthorized unless @current_user
  end
end
