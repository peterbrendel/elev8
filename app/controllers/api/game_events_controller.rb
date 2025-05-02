# frozen_string_literal: true

class Api::GameEventsController < ApplicationController
  def create
    Rails.logger.info("Creating game event with params: #{params}")
    @game_event = GameEvent.new(
      game_name: game_event_params[:game_name],
      event_type: game_event_params[:type],
      occurred_at: game_event_params[:occurred_at],
      user_id: current_user_id
    )

    if @game_event.save
      render json: {}, status: :created
    else
      render json: { errors: @game_event.errors.full_messages }, status: :unprocessable_entity
    end
    # apparently enum throws ArgumentError when object is created instead of when it is saved
    # this probably shouldnt be a definitive solution, but it's fine for this assignment
  rescue ArgumentError => e
    if e.message.include?('event_type')
      render json: { errors: e.message }, status: :unprocessable_entity
    else
      raise e
    end
  end

  def game_event_params
    params.require(:game_event).permit(:game_name, :type, :occurred_at)
  end
end
