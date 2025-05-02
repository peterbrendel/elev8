# frozen_string_literal: true

class Api::UserController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    user = User.create(user_params)

    if user.valid?
      render json: {}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def user_params
    params.permit(:email, :password)
  end
end
