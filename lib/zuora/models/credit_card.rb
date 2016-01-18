class Zuora::Models::CreditCard
  extend ValidationPredicates
  include SchemaModel

  schema :credit_card,
    card_type: {
      required?: true,
      type: String,
      valid?: one_of(%w(Visa MasterCard AmericanExpress Discover))
    },
    expiration_month: {
      doc: 'Two-digit expiration month (01-12)',
      type: String,
      required?: true
    },
    card_number: {
      type: String,
      doc: "Card number, up to 16 characters.  Once created, this field can't
            be updated or queried, and is only available in
            masked format (e.g., XXXX-XXXX-XXXX-1234).",
      required?: true
    },
    expiration_year: {
      type: Numeric,
      doc: 'Four-digit expiration year',
      required?: true
    },
    security_code: {
      type: String,
      doc: "The CVV or CVV2 security code of the card. To ensure PCI compliance,
            this value isn't stored and can't be queried. For more information,
            see How do I control what information Zuora sends over to the
            Payment Gateway?",
      required?: true
    },

    card_holder_info: {
      doc: "Container for cardholder information. If provided, Zuora will only
            use this information for this card.  If not provided, Zuora will
            use the account's existing bill-to contact information for
            this card.",
      schema: Zuora::Models::CardHolderInfo
    }
end
