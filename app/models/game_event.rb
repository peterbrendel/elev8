# frozen_string_literal: true

class GameEvent < ApplicationRecord
  belongs_to :user

  validates :game_name, presence: true
  validates :occurred_at, presence: true
  validates :event_type, presence: true
  
  EVENT_TYPES = { "COMPLETED" => 0 }.freeze
  enum :event_type, EVENT_TYPES
end
