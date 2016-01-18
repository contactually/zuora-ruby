class Zuora::Models::Tier
  extend ValidationPredicates
  include SchemaModel

  schema :tier,
    tier: {
      required?: true,
      type: Numeric,
      doc: 'Unique number that identifies the tier that the price applies to.'
    },

    starting_unit: {
      doc: 'Starting number of a range of units for the tier.',
      type: Numeric
    },

    ending_unit: {
      required?: true,
      type: Numeric, # decimal
      doc: 'End number of a range of units for the tier.'
    },

    price: {
      required?: true,
      doc: 'Price of the tier if the charge is a flat fee,
       or the price of each unit in the tier if the charge model
       is tiered pricing.',
      type: Numeric, # currency
    },

    price_format: {
      doc: 'Indicates if pricing is a flat fee or is per unit.',
      type: String,
      valid?: one_of(%w(PerUnit FlatFee))
    }
end
