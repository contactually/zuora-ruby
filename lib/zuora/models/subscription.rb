class Zuora::Models::Subscription
  include SchemaModel

  schema :subscription,
    add: {
      schema: [Zuora::Models::SubscriptionAdd]
    },

    update: {
      schema: [Zuora::Models::SubscriptionUpdate]
    },

    remove: {
      schema: [Zuora::Models::SubscriptionUpdate]
    },

    account_key: {
      doc: 'Customer account number or ID',
      type: String,
    },

    invoice_owner_account_key: {
      doc: 'Invoice owner account number or ID',
      type: String,
      limited_availability?: true
    },

    term_type: {
      doc: 'Possible values are: TERMED, EVERGREEN.
           See Subscriptions for more information.',
      type: String,
    },

    contract_effective_date: {
      doc: 'Effective contract date for this subscription, as yyyy-mm-dd',
      type: Date,
    },

    service_activation_date: {
      doc: 'The date on which the services or products within a subscription
            have been activated and access has been provided to the customer,
            as yyyy-mm-dd.

            Default value is dependent on the value of other fields.
             See Notes section below for more details.',
      type: Date
    },

    customer_acceptance_date: {
      doc: 'The date on which the services or products within a subscription
            have been accepted by the customer, as yyyy-mm-dd.

           Default value is dependent on the value of other fields.
           See Notes section below for more details.',
      type: Date
    },

    term_start_date: {
      doc: 'The date on which the subscription term begins, as yyyy-mm-dd.
         If this is a renewal subscription, this date is different from the
           subscription start date.',
      type: Date
    },

    initial_term: {
      doc: 'The length of the period for the first subscription term.
            Default is 0.

            If termType is TERMED, then this field is required, and
            the value must be greater than 0. If termType is EVERGREEN,
            this field is ignored.',

      type: Numeric,
    },

    initial_term_period_type: {
      type: String,
      doc: 'The period type for the first subscription term.

        This field is used with the InitialTerm field to specify
        the initial subscription term.

        Values are:

        Month (default), Year, Day, Week'
    },

    auto_renew: {
      doc: '',
      type: Boolean
    },

    renewal_term: {
      doc: 'The length of the period for the subscription renewal term.
            Default is 0.',
      type: Numeric,
    },

    renewal_term_period_type: {
      type: String,
      doc: 'The period type for the first subscription term.

        This field is used with the RenewalTerm field to specify
        the subscription renewal term.

        Values are:

        Month (default), Year, Day, Week',
    },

    renewal_setting: {
      doc: 'Specifies whether a termed subscription will remain termed or
             change to evergreen when it is renewed.

            Values:

            RENEW_WITH_SPECIFIC_TERM (default)
            RENEW_TO_EVERGREEN',
      type: String,
    },

    notes: {
      doc: 'String of up to 500 characters',
      type: String,
    },

    invoice: {
      doc: 'Creates an invoice for a subscription. The invoice generated in this
             operation is only for this subscription, not for the entire
             customer account.

            If the value is true, an invoice is created. If the value is false,
            no action is taken.

            The default value is true.',
      type: Boolean
    },
    invoice_collect: {
      type: Boolean
    },

    collect: {
      doc: 'Collects an automatic payment for a subscription. The collection
            generated in this operation is only for this subscription, not for
             the entire customer account.

            If the value is true, the automatic payment is collected.
            If the value is false, no action is taken.

            The default value is true.

            Prerequisite: invoice must be true. ',
      type: Boolean
    },

    invoice_separately: {
      doc: 'Separates a single subscription from other subscriptions and
            invoices the charge independently.

            If the value is true, the subscription is billed separately from
            other subscriptions. If the value is false, the subscription is
            included with other subscriptions in the account invoice.

            The default value is false.

            Prerequisite: The default subscription setting Enable Subscriptions
            to be Invoiced Separately must be set to Yes.',
      type: Boolean
    },

    apply_credit_balance: {
      doc: 'Applies a credit balance to an invoice.
            If the value is true, the credit balance is applied to the invoice.
            If the value is false, no action is taken.
            Prerequisite: invoice must be true.

            To view the credit balance adjustment, retrieve the details
            of the invoice using the Get Invoices method.',
      type: Boolean
    },

    invoice_target_date: {
      doc: 'Date through which to calculate charges if an invoice is generated,
            as yyyy-mm-dd. Default is current date.',
      type: Date
      # TODO: specifiy serialization function
    },

    subscribe_to_rate_plans: {
      doc: 'Container for one or more rate plans for this subscription.',
      schema: [Zuora::Models::Plan]
    }
end
