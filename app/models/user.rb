# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :game_events, dependent: :destroy

  # leave small entropy since it's not a real app
  validates :password, password_strength: { min_entropy: 10, min_word_length: 8 }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  before_validation :downcase_email
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  # TODO: not touching email confirmation for now

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
