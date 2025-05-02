# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionStatusService do
  describe '.fetch_status' do
    let(:user_id) { 1 }
    let(:url) { "#{SubscriptionStatusService::BASE_URL}/api/v1/users/#{user_id}/billing" }
    let(:token) { SubscriptionStatusService::TOKEN }

    context 'when the API returns gracefully' do
      before do
        stub_request(:get, url)
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 200, body: { subscription_status: }.to_json)
      end

      context 'and responds active' do
        let(:subscription_status) { 'active' }

        it 'returns active' do
          expect(described_class.fetch_status(user_id)).to eq('active')
        end
      end

      context 'and responds expired' do
        let(:subscription_status) { 'expired' }

        it 'returns expired' do
          expect(described_class.fetch_status(user_id)).to eq('expired')
        end
      end

      context 'and responds non-sense' do
        let(:subscription_status) { 'non-sense' }

        it 'returns nil' do
          expect(described_class.fetch_status(user_id)).to be_nil
        end
      end
    end

    context 'when the API returns an error' do
      before do
        stub_request(:get, url)
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 500)
      end

      it 'returns nil' do
        expect(described_class.fetch_status(user_id)).to be_nil
      end
    end

    context 'when the response is not valid JSON' do
      before do
        stub_request(:get, url)
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(status: 200, body: 'invalid json')
      end

      it 'returns nil' do
        expect(described_class.fetch_status(user_id)).to be_nil
      end
    end
  end
end
