# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :game_events, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
