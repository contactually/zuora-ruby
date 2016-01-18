module Zuora
  module Accounts
    class GetSummary
      include ResourceModel
      extend ValidationPredicates

      resource :get_account_summary,
        human_name: 'Get account summary',
        doc_url: %w(https://knowledgecenter.zuora.com/BC_Developers/
                    REST_API/B_REST_API_reference/Accounts/
                    3_GET_account_summary).join(''),

        description: "This REST API reference describes how to
               retrieve basic information about a customer account.
               This REST call is a quick retrieval that doesn't
               include the account's subscriptions, invoices,
               payments, or usage details. Use the Get account
               summary to get more detailed information about an
               account.",
        cors: true,
        request: {
          method: :GET,
          content_type: 'application/json',
          urls: {
            production:
              'https://api.zuora.com/rest/v1/accounts/:account_key/summary',
            sandbox:
              'https://apisandbox-api.zuora.com/rest/v1/accounts/:account_key/summary'
          }
        },

        response: {

        }
    end
  end
end
