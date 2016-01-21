class Zuora::Models::Account
  include SchemaModel

  schema :account,
    batch: {
      doc: 'The alias name given to a batch. A string of 50
               characters or less.',
      type: String
    },

    account_number: {
      type: String,
      doc: 'A unique account number, up to 50 characters that
               do not begin with the default account number prefix.
               If no account number is specified, one is generated.'
    },

    auto_pay: {},

    bill_to_contact: {
      schema: Zuora::Models::Contact,
      doc: 'Container for bill-to contact information for this account.
                      If you do not provide a sold-to contact, the bill-to
                      contact is copied to sold-to contact. Once the sold-to
                      contact is created, changes to billToContact will not
                      affect soldToContact and vice versa.'
    },

    bill_cycle_day: {
      type: String,
      doc: %q(The account's bill cycle day (BCD), when bill runs
                generate invoices for the account.  Specify any day of the
                month  (1-31, where 31 = end-of-month), or 0 for auto-set.

                If no subscription is being created, this field is
                required. If a subscription is being created, this
                field is optional, and defaults to the day-of-the-month
                of te subscription's contractEffectiveDate." )
    },

    crm_id: {
      type: String,
      doc: 'CRM account ID for the account, up to 100 characters'
    },

    currency: {
      type: String,
      doc: 'A currency as defined in Z-Billing Settings in the
            Zuora UI'
    },

    credit_card: {
      schema: Zuora::Models::CreditCard
    },

    name: {
      type: String,
      doc: 'Account name, up to 255 characters'
    },

    hpm_credit_card_payment_method_id: {
      type: String,
      doc: 'The ID of the HPM credit card payment method associated with
                      this account. You must provide either this field or the
                      creditCard structure, but not both.'
    },

    notes: {
      type: String,
      doc: 'A string of up to 65,535 characters'
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
                      left unassigned, the Account will use the Default
                       Gateway.'
    },

    payment_term: {
      type: String,
      doc: 'Payment terms for this account. Possible values are
               "Due Upon Receipt", "Net 30", "Net 60", "Net 90".'
    },

    sold_to_contact: {
      schema: Zuora::Models::Contact
    },

    subscription: {
      doc: 'Container for subscription information, used if creating a
               subscription for the new account at the time of account
               creation.',
      schema: Zuora::Models::Subscription
    }
end
