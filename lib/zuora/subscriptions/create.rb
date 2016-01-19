require_relative '../schemas/subscription'

module Zuora
  module Subscriptions
    class Create
      include ResourceModel

      resource :create_subscription,
        human_name: 'Create subscription',
        doc_url:    %w(https://knowledgecenter.zuora.com/BC_Developers
                       /REST_API/B_REST_API_reference/Subscriptions
                       /02_Create_subscription).join(''),

        description:
                    'This REST API reference describes how to create a new
subscription for an existing customer account.',

        cors:       true,
        request:    {
          method: :get,
          schema: Zuora::Models::Subscription,
          urls:   {
            production: 'https://api.zuora.com/rest/v1/subscriptions',
            sandbox:    'https://apisandbox-api.zuora.com/rest/v1/subscriptions'
          }
        }
    end
  end
end
