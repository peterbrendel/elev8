# frozen_string_literal: true

module JsonWebToken
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.env['JWT_SECRET_KEY']

  def encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new body
  end
end
