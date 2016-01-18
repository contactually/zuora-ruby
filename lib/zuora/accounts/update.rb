module Zuora
  module Accounts
    class Update
      include ResourceModel
      extend ValidationPredicates

      resource :update_account,
        human_name: 'Update account',
        doc_url: %w(https://knowledgecenter.zuora.com/BC_Developers
                    /REST_API/B_REST_API_reference/Accounts
                    /4_Update_account).join(''),

        description: 'This REST API reference describes how to update a customer
          account by specifying the account-key.',

        parameters: {
          account_key: {
            doc: 'Account number or account ID'
          }
        },

        request: {
          method: :PUT,

          content_type: 'application/json',

          urls: {
            production: 'https://api.zuora.com/rest/v1/accounts/:account_key',
            sandbox: 'https://api.zuora.com/rest/v1/accounts/:account_key'
          },

          body: {
            batch: {
              doc: 'The alias name given to a batch. A string of 50
            characters or less.'
            },

            auto_pay: {
              type: Boolean,
              required?: true
            },

            bill_to_contact: {
              required?: true,
              doc: 'Container for bill-to contact information for this account.
If you do not provide a sold-to contact, the bill-to contact
is copied to sold-to contact. Once the sold-to contact is
created, changes to billToContact will not affect
soldToContact and vice versa.)',
              schema: nil # TODO: Contact
            },

            crm_id: {
              type: String,
              doc: 'CRM account ID for the account, up to 100 characters',
              valid?: max_length(100)
            },

            currency: {
              type: String,
              valid?: length(3),
              doc: 'A currency as defined in Z-Billing Settings in the
  Zuora UI'
            },

            name: {
              type: String,
              required?: true,
              doc: 'Account name, up to 255 characters'
            },

            notes: {
              type: String,
              doc: 'A string of up to 65,535 characters',
              valid?: max_length(65_325)
            },

            invoice_template_id: {
              type: String,
              doc:  'Invoice template ID, configured in Z-Billing Settings'
            },

            communication_profile_id: {
              type: String,
              doc: 'ID of a communication profile, as described in the
  Knowledge Center'
            },

            payment_gateway: {
              type: String,
              doc: 'The name of the payment gateway instance. If null or
  left unassigned, the Account will use the Default Gateway.'
            }
          }
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
            }
          }
        }
    end
  end
end
