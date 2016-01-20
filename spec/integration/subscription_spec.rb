require 'spec_helper'

describe 'creates/updates a subscription' do
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::Client.new username, password, true }

  context 'when creating a new subscription' do
    let(:account_id) { '2c92c0fa525e25d50152611a674074a2' }
    let(:product_rate_plan_id) { '2c92c0f950fa763f01510cbb937812dd' }
    let(:subscription) do
      build(
        :subscription,
        account_key: account_id,
        term_type: 'EVERGREEN',
        contract_effective_date: Date.today,
        service_activation_date: Date.today,
        auto_renew: true,
        subscribe_to_rate_plans: [
          {
            product_rate_plan_id: product_rate_plan_id
          }
        ]
      )
    end

    context 'with valid data' do
      let(:cassette) { 'create_subscription_success' }

      it 'creates a new subscription' do
        VCR.use_cassette(cassette, match_requests_on: [:path]) do
          response = client.post('/rest/v1/subscriptions', subscription)
          expect(response.body['success']).to be_truthy
          expect(response.body['subscriptionId'].present?).to be_truthy
        end
      end
    end

    context 'with invalid data' do
      let(:cassette) { 'create_subscription_failure' }
      let(:product_rate_plan_id) { 'INVALID_ID' }

      it 'returns an error' do
        VCR.use_cassette(cassette, match_requests_on: [:path]) do
          response = client.post('/rest/v1/subscriptions', subscription)
          expect(response.body['success']).to be_falsey
          expect(response.body['subscriptionId'].present?).to be_falsey
        end
      end
    end
  end

  context 'when updating a subscription rate plan' do
    let(:subscription_id) { '2c92c0fb525e37ea01526120f38f73db' }
    let(:rate_plan_id) { '2c92c0fb525e37ea01526120f37f73d9' }
    let(:subscription) do
      build(
        :subscription,
        invoice_collect: true,
        apply_credit_balance: true,
        remove: [
          {
            rate_plan_id: rate_plan_id,
            contract_effective_date: Date.today
          }
        ],
        add: [
          {
            product_rate_plan_id: '2c92c0f850fa443e01510cbb557e3cf8',
            contract_effective_date: Date.today
          }
        ]
      )
    end
    let(:url) { "/rest/v1/subscriptions/#{subscription_id}" }

    context 'with valid data' do
      let(:cassette) { 'update_subscription_rate_plan_success' }

      it 'creates a new subscription' do
        VCR.use_cassette(cassette, match_requests_on: [:path]) do
          response = client.put(url, subscription)
          expect(response.body['success']).to be_truthy
          expect(response.body['subscriptionId'].present?).to be_truthy
        end
      end
    end

    context 'with invalid data' do
      let(:cassette) { 'update_subscription_rate_plan_failure' }
      let(:product_rate_plan_id) { 'INVALID_ID' }

      it 'returns an error' do
        VCR.use_cassette(cassette, match_requests_on: [:path]) do
          response = client.put(url, subscription)
          expect(response.body['success']).to be_falsey
          expect(response.body['subscriptionId'].present?).to be_falsey
        end
      end
    end
  end

  context 'when updating a subscription quantity' do
    let(:subscription_id) { '2c92c0fa525e261a01526127f6416c8b' }
    let(:rate_plan_id) { '2c92c0fa525e261a01526127f6496c8f' }
    let(:rate_plan_charge_id) { '2c92c0fa525e261a01526127f6496c90' }
    let(:subscription) do
      build(
        :subscription,
        invoice_collect: true,
        apply_credit_balance: true,
        update: [
          {
            rate_plan_id: rate_plan_id,
            contract_effective_date: Date.today,
            charge_update_details: [
              {
                rate_plan_charge_id: rate_plan_charge_id,
                quantity: '2'
              }
            ]
          }
        ]
      )
    end
    let(:url) { "/rest/v1/subscriptions/#{subscription_id}" }

    context 'with valid data' do
      let(:cassette) { 'update_subscription_quantity_success' }

      it 'creates a new subscription' do
        VCR.use_cassette(cassette, match_requests_on: [:path]) do
          response = client.put(url, subscription)
          expect(response.body['success']).to be_truthy
          expect(response.body['subscriptionId'].present?).to be_truthy
        end
      end
    end

    context 'with invalid data' do
      let(:cassette) { 'update_subscription_quantity_failure' }
      let(:rate_plan_charge_id) { 'INVALID_ID' }

      it 'returns an error' do
        VCR.use_cassette(cassette, match_requests_on: [:path]) do
          response = client.put(url, subscription)
          expect(response.body['success']).to be_falsey
          expect(response.body['subscriptionId'].present?).to be_falsey
        end
      end
    end
  end
end
