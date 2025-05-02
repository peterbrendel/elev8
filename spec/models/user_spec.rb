require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    let!(:user) { create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it "should validate weak password" do
      user = User.new(email: "email@the-brendel.dev", password: "weak")
      expect(user).not_to be_valid
    end

    it "should downcase email before validation" do
      user = User.new(email: "EMAIL@THE-BRENDEL.DEV", password: "It'sS4f3!")
      user.valid?
      expect(user.email).to eq("email@the-brendel.dev")
    end
  end
end
