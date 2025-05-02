require 'rails_helper'

RSpec.describe "Api::Sessions", type: :request do
  let(:password) { 'super-safe-password' }
  let(:user) { create(:user, password:) }

  describe "GET /create" do
    it "authenticates a user with correct credentials" do
      post api_sessions_path, params: { email: user.email, password: }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["token"]).not_to be_nil
    end

    it "returns an error with incorrect credentials" do
      post api_sessions_path, params: { email: user.email, password: 'wrong-password' }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["errors"]).to include("Invalid email or password")
    end
  end
end
