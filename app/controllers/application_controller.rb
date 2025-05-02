# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JsonWebToken

  attr_reader :current_user_id

  before_action :authenticate_request
  
  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last

    @current_user_id = decode(token)&.dig('user_id') if token.present?

    render json: { errors: ['Not Authorized'] }, status: :unauthorized unless @current_user_id
  end
end
