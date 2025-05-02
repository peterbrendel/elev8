require 'rails_helper'

RSpec.describe "Api::User", type: :request do
  let(:email) { "my-email@peter-brendel.dev" }
  let(:password) { "super-safe-password" }

  describe "post /create" do
    it "creates a user" do
      post api_user_path, params: { email:, password: }

      expect(response).to have_http_status(:created)
      # expect(JSON.parse(response.body)).to be_empty
    end
  end
end
