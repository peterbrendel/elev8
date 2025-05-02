# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class SubscriptionStatusService
  # if the API was more complex this would inherit an integration service
  # and probably use Faraday or HTTParty
  # where we would handle logging and the response and errors in a more standaradized way
  # control rate limiting and retries
  # be able to stub the requests and responses for testing
  # but for the sake of the assignment, let's keep it simple

  BASE_URL = ENV.fetch('ELEVATEAPP_SERVICE_URL')
  ENDPOINT_URL = "#{BASE_URL}/api/v1/users/:user_id/billing"
  TOKEN = ENV.fetch('ELEVATEAPP_SERVICE_TOKEN')

  def self.fetch_status(user_id)
    uri = URI.parse(ENDPOINT_URL.gsub(':user_id', user_id.to_s))
    response = Net::HTTP.get_response(uri, { 'Authorization' => "Bearer #{TOKEN}" })

    if response.is_a?(Net::HTTPSuccess)
      parse_response(response.body)
    else
      nil
    end
  end

  private

  RESPONSE_MAPPINGS = {
    'active' => 'active',
    'expired' => 'expired'
  }

  def self.parse_response(body)
    data = JSON.parse(body)

    RESPONSE_MAPPINGS[data['subscription_status']]
  rescue JSON::ParserError
    nil
  end
end
