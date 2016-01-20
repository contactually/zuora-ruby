class Zuora::Models::SubscriptionUpdate
  include SchemaModel

  schema :subscription_update,
    rate_plan_id: {
      doc: 'ID of a rate plan for this subscription',
      type: String
    },

    contract_effective_date: {
      type: Date
    },

    charge_update_details: {
      schema: [Zuora::Models::ChargeUpdate]
    }
end
