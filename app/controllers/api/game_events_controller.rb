# frozen_string_literal: true

class Api::GameEventsController < ApplicationController
  def create
    # Considering there would be more work to do, we would probably use a service to handle the controller process
    # we could benefit from a GameEventService, it would enable us to reuse the logic in other controllers or jobs
    # and also to test it in isolation.

    # this logic specifically could be handled by a job, thinking of UX, it doesn't really matter to the user
    # as long as the event is created we should free the user from waiting for the response
    # but for the sake of the assignment, let's keep it simple (and also not prematurely optimize)
    @game_event = GameEvent.new(
      game_name: game_event_params[:game_name],
      event_type: game_event_params[:type],
      occurred_at: game_event_params[:occurred_at],
      # context app/controllers/application_controller.rb
      # we would have paid an unecessary database RTT to fetch the user in this case
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
    if e.message.include?("event_type")
      render json: { errors: e.message }, status: :unprocessable_entity
    else
      raise e
    end
  end

  def game_event_params
    params.require(:game_event).permit(:game_name, :type, :occurred_at)
  end
end
