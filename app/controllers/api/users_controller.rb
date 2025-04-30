# frozen_string_literal: true

class Api::UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create] # Allow unauthenticated users to create accounts
  
    def create
      user = User.new(user_params)
      if user.save
        render json: {}, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      render json: {
        user: {
          id: current_user.id,
          email: current_user.email,
          stats: {
            total_games_played: current_user.game_events.count
          }
        }
      }
    end
  
    private
  
    def user_params
      params.permit(:email, :password)
    end
  end
  