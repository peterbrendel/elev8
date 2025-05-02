require 'rails_helper'

RSpec.describe "Api::GameEvents", type: :request do
  include JsonWebToken
  let(:user) { create(:user) }

  describe "POST /create" do
    it "creates a game event" do
      post api_user_game_events_path, params: {
        game_event: {
          game_name: "Test Game",
          type: "COMPLETED",
          occurred_at: Time.current
        }
      }, headers: { 'Authorization' => encode(user_id: user.id) }

      expect(response).to have_http_status(:created)
    end

    it "links the game event to the user" do
      post api_user_game_events_path, params: {
        game_event: {
          game_name: "Test Game",
          type: "COMPLETED",
          occurred_at: Time.current
        }
      }, headers: { 'Authorization' => encode(user_id: user.id) }

      expect(response).to have_http_status(:created)
      expect(GameEvent.last.user_id).to eq(user.id)
    end

    describe "with invalid params" do
      it "returns an error for invalid event_type" do
        post api_user_game_events_path, params: {
          game_event: {
            game_name: "Test Game",
            type: "INVALID_TYPE",
            occurred_at: Time.current
          }
        }, headers: { 'Authorization' => encode(user_id: user.id) }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("'INVALID_TYPE' is not a valid event_type")
      end

      it "returns an error when game name is missing" do
        post api_user_game_events_path, params: {
          game_event: {
            type: "COMPLETED",
            occurred_at: Time.current
          }
        }, headers: { 'Authorization' => encode(user_id: user.id) }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Game name can't be blank")
      end

      it "returns an error when event_type is missing" do
        post api_user_game_events_path, params: {
          game_event: {
            game_name: "Test Game",
            occurred_at: Time.current
          }
        }, headers: { 'Authorization' => encode(user_id: user.id) }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Event type can't be blank")
      end

      it "returns an error when occurred_at is missing" do
        post api_user_game_events_path, params: {
          game_event: {
            game_name: "Test Game",
            type: "COMPLETED"
          }
        }, headers: { 'Authorization' => encode(user_id: user.id) }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Occurred at can't be blank")
      end

      it "returns an error when occurred_at is not a valid datetime" do
        post api_user_game_events_path, params: {
          game_event: {
            game_name: "Test Game",
            type: "COMPLETED",
            occurred_at: "invalid_datetime"
          }
        }, headers: { 'Authorization' => encode(user_id: user.id) }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Occurred at can't be blank")
      end

      it "returns an error when the user is not authenticated" do
        post api_user_game_events_path, params: {
          game_event: {
            game_name: "Test Game",
            type: "COMPLETED",
            occurred_at: Time.current
          }
        }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["errors"]).to include("Not Authorized")
      end
    end
  end
end
