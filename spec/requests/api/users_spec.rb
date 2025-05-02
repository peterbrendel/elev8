require "rails_helper"

RSpec.describe "Api::User", type: :request do
  let(:email) { "my-email@peter-brendel.dev" }
  let(:password) { "It'sS4f3" }

  describe "post /create" do
    it "creates a user" do
      post api_user_path, params: { email:, password: }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to be_empty

      expect(User.last.email).to eq(email)
      expect(User.last.authenticate(password).present?).to be true
    end

    describe "with invalid params" do
      it "returns an error when email is missing" do
        post api_user_path, params: { password: }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Email can't be blank")
      end

      it "returns an error when password is missing" do
        post api_user_path, params: { email: }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Password can't be blank")
      end

      it "returns an error when email is invalid" do
        post api_user_path, params: { email: "invalid-email", password: }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Email is invalid")
      end

      it "returns an error when password doesn't meet criteria" do
        post api_user_path, params: { email:, password: "abcdefgh" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Password is too weak")
      end
    end
  end
end
