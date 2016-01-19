module Zuora
  module Accounts
    class Get
      include ResourceModel
      extend ValidationPredicates

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

        response: {

        }
    end
  end
end
