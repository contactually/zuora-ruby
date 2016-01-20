class Zuora::Models::SubscriptionAdd
  include SchemaModel

  schema :subscription_add,
    product_rate_plan_id: {
      doc: 'ID of a rate plan for this subscription',
      type: String,
    },

    contract_effective_date: {
      type: Date
    }
end
