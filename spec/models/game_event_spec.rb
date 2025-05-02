require 'rails_helper'

RSpec.describe GameEvent, type: :model do
  describe "validations" do
    it { should validate_presence_of(:game_name) }
    it { should validate_presence_of(:event_type) }
    it { should validate_presence_of(:occurred_at) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "enum" do
    it { should define_enum_for(:event_type).with_values(["COMPLETED"]) }
  end
end
