require_relative '../schemas/account'

module Zuora
  module Accounts
    class Create
      include ResourceModel

      resource :create_account,
        human_name: 'Create account',
        doc_url: %w(https://knowledgecenter.zuora.com
                    /BC_Developers/REST_API/B_REST_API_reference
                    /Accounts/1_Create_account).join(''),

        description: '
           This REST API reference describes how to create a customer account
           with a credit-card payment method, a bill-to contact, and an
           optional sold-to contact. Request and response field descriptions
           and sample code are provided. Use this method to optionally create
           a subscription, invoice for that subscription, and collect payment
           through the default payment method. The transaction is atomic;
           if any part fails for any reason, the entire transaction is
           rolled back.
           ',
        cors: true,
        request: {
          method: :PUT,
          content_type: 'application/json',
          urls: {
            production: 'https://api.zuora.com/rest/v1/accounts',
            sandbox: 'https://api.zuora.com/rest/v1/accounts'
          },

          schema: nil # Zuora::Models::Account.schema
        },

        response: {
          content_type: 'application/json',
          body: {
            success: {
              doc: 'Contains true if successful, otherwise false.',
              type: Boolean
            },
            process_id: {
              doc: 'Internal process ID to assist Zuora support.
                    Only returned if success is false.',
              type: String
            },

            reasons: {
              code: {
                doc: 'Eight-digit numeric error code',
                type: String
              },
              message: {
                doc: 'Description of the error',
                type: String
              }
            },

            account_id: {
              doc: 'Auto-generated account ID',
              type: String
            },

            account_number: {
              doc: 'Account number',
              type: String
            },

            payment_method_id: {
              doc: 'ID of the payment method that was set up at account
                    creation, which automatically becomes the default payment
                    method for this account.',
              type: String
            },

            subscription_id: {
              doc: 'The ID of the resulting new subscription',
              type: Boolean
            },

            invoice_id: {
              doc: 'ID of the invoice generated at account creation,
                    if applicable',
              type: Boolean
            },

            payment_id: {
              doc: 'ID of the payment collected on the invoice generated
                    at account creation, if applicable',
              type: Boolean
            },

            paid_amount: {
              doc: 'Amount collected on the invoice generated at account
                    creation, if applicable',
              type: Boolean
            },

            contracted_mrr: {
              doc: 'Contracted monthly recurring revenue of the subscription',
              type: Numeric
            },

            total_contracted_value: {
              doc: 'Total contracted value of the subscription',
              type: Numeric
            }
          }
        }
    end
  end
end
