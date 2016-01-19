class Zuora::Models::SubscriptionUpdate
  extend ValidationPredicates
  include SchemaModel

  schema :subscription_update,
    rate_plan_id: {
      doc: 'ID of a rate plan for this subscription',
      type: String,
      required?: true
    },
    contract_effective_date: {
      required?: true,
      type: Date
    },
    charge_update_details: {
      schema: [Zuora::Models::ChargeUpdate]
    }
end