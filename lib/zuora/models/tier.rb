class Zuora::Models::Tier
  include SchemaModel

  schema :tier,
    tier: {
      type: Numeric,
      doc: 'Unique number that identifies the tier that the price applies to.'
    },

    starting_unit: {
      doc: 'Starting number of a range of units for the tier.',
      type: Numeric
    },

    ending_unit: {
      type: Numeric, # decimal
      doc: 'End number of a range of units for the tier.'
    },

    price: {
      doc: 'Price of the tier if the charge is a flat fee,
       or the price of each unit in the tier if the charge model
       is tiered pricing.',
      type: Numeric, # currency
    },

    price_format: {
      doc: 'Indicates if pricing is a flat fee or is per unit.',
      type: String,
    }
end
