# frozen_string_literal: true

class Api::SessionsController < ApplicationController
  include JsonWebToken

  skip_before_action :authenticate_request, only: [ :create ]

  def create
    user = User.find_by(email: permit_params[:email])

    if user&.authenticate(permit_params[:password])
      token = encode({ user_id: user.id })
      render json: { token: }, status: :created
    else
      render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
    end
  end

  def permit_params
    params.permit(:email, :password)
  end
end
