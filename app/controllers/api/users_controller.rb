# frozen_string_literal: true

class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    user = User.create(user_params)

    if user.valid?
      render json: {}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    # here we pay the database RTT to fetch the user
    user = User.find(current_user_id)

    # in a big project this would be a serializer to separate the concerns and DRY
    render json: {
      user: {
        id: user.id,
        email: user.email,
        stats: {
          total_games_played: user.completed_game_events.count
        },
        # Note: the service recalculates the subscription status of users every 24h.
        # this indicates that I could cache the response for 24h, but the cache invalidation timeframe isn't specified
        subscription_status: SubscriptionStatusService.fetch_status(user.id)
      }
    }, status: :ok
  end

  def user_params
    params.permit(:email, :password)
  end
end
