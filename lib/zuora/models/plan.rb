class Zuora::Models::Plan
  include SchemaModel

  schema :product_rate_plan,
    product_rate_plan_id: {
      required?: true,
      doc: 'ID of a product rate plan for this subscription.'
    },

    charge_overrides: {
      doc: 'This optional container is used to override the quantity of
            one or more product rate plan charges for this subscription.',
      schema: [Zuora::Models::Charge]
    }
end
