module Zuora
  module Resources
    class Accounts
      include ResourceModel
      extend ValidationPredicates

      resource :update_subscription,
        human_name: 'Update subscription',
        http_method: :PUT,
        doc_url: %w(https://knowledgecenter.zuora.com
            /BC_Developers/REST_API/B_REST_API_reference
            /Subscriptions/5_Update_subscription).join(''),

        description: %q(
          Use this call to make the following kinds of changes to a subscription:

          * Add a note
          * Change the renewal term or auto-renewal flag
          * Change the term length or change between evergreen and termed
          * Add a new product rate plan
          * Remove an existing subscription rate plan
          * Change the quantity or price of an existing subscription rate plan
        ),
        request: {
         uris: {
           production:
             %w(https://api.zuora.com/rest/v1/'
                subscriptions/{subscription_key}').join(''),

           sandbox:
             %w(https://api.zuora.com/rest/v1/
                subscriptions/{subscription_key}).join('')
         },

         parameters: {
           subscription_key: {
             required: true,
             description: 'Subscription number or ID'
           }
         },

         body: {
           auto_renew: {
             type: Boolean
           },

           apply_credit_balance: {
             type: String
           },

           account_key: {
             type: String,
             required?: true
           },

           contract_effective_date: {
             type: Date,
             required?: true
           },

           collect: {
             type: String
           },

           customer_acceptance_date: {
             type: Date
           },

           term_type: {
             type: String,
             required?: true,
             valid?: one_of(Zuora::SUBSCRIPTION_TERM_TYPES)
           },

           initial_term: {
             type: String,
             required?: other_attr_eq(:term_type, 'EVERGREEN')
           }
         }
        },

        response: {
         body: {
           success: {
             doc: 'Contains true if successful, otherwise false.',
             type: Boolean
           },
           process_id: {
             doc: 'Internal process ID to assist Zuora support.
             Only returned if success is false.',
             type: Boolean
           },

           subscription_id: {
             doc: 'The ID of the resulting new subscription',
             type: Boolean
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

           invoice_id: {
             doc: 'The ID of the resulting new subscription',
             type: Boolean
           },

           payment_id: {
             doc: 'Payment ID, if a payment is collected',
             type: Boolean
           },

           paid_amount: {
             doc: 'Payment amount, if a payment is collected',
             type: Boolean
           },

           total_delta_mrr: {
             doc: 'Change in the subscription monthly recurring revenue as a
            result of the update',
             type: Numeric
           }
         }
        }
    end
  end
end
