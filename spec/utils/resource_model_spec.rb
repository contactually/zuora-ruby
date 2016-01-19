require 'spec_helper'

class SchemaModelSpec
  include SchemaModel
  extend ValidationPredicates

  schema :schema_model_spec,
    account_key: {
      type: Numeric,
      required?: true,
      valid?: -> (v) { v > 0 }
    },
    label: {
      type: String,
      valid?: max_length(5)
    }
end

class ResourceModelSpec
  include ResourceModel

  resource :get_account,
    human_name: 'Get account',
    doc_url: %w(https://knowledgecenter.zuora.com/
                    BC_Developers/REST_API/B_REST_API_reference/Accounts/
                    2_Get_account_basics).join(''),

    description: "This REST API reference describes how to
                  retrieve basic information about a customer account.
                  This REST call is a quick retrieval that doesn't
                  include the account's subscriptions, invoices,
                  payments, or usage details. Use the Get account
                  summary to get more detailed information about an
                  account.",
    cors: true,
    request: {
      method: :get,
      content_type: 'application/json',
      urls: {
        production:
          'https://api.zuora.com/rest/v1/accounts/:account_key',
        sandbox:
          'https://apisandbox-api.zuora.com/rest/v1/accounts/:account_key'
      }
    },
    schema: SchemaModelSpec

end

describe ResourceModelSpec do
  let(:model) { SchemaModelSpec.new account_key: 1, label: 'Hello' }

  # Authentication
  let(:username) { ENV['ZUORA_SANDBOX_USERNAME'] }
  let(:password) { ENV['ZUORA_SANDBOX_PASSWORD'] }
  let(:client) { Zuora::Client.new username, password, true }

  let(:subject) do
    ResourceModelSpec.new client, model
  end

  let(:url) { 'https://apisandbox-api.zuora.com/rest/v1/accounts/1'}
  let(:meth) { :get }

  it { expect(subject.url).to eq url }
  it { expect(subject.request_method).to eq meth }
  # it { expect(subject.exec!.status).to eq 200 }

end
