class Zuora::Models::ChargeUpdate
  extend ValidationPredicates
  include SchemaModel

  schema :charge_update,
    rate_plan_charge_id: {
      doc: 'Subscription ID',
      type: String,
      required?: true
    },

    quantity: {
      type: Numeric
    }
end
