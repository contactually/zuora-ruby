class Zuora::Models::SubscriptionAdd
  extend ValidationPredicates
  include SchemaModel

  schema :subscription_add,
    product_rate_plan_id: {
      doc: 'ID of a rate plan for this subscription',
      type: String,
      required?: true
    },

    contract_effective_date: {
      required?: true,
      type: Date
    }
end
