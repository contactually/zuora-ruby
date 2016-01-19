class Zuora::Models::CardHolderInfo
  extend ValidationPredicates
  include SchemaModel

  schema :card_holder_info,
    card_holder_name: {
      required?: true,
      doc: %(The card holder's full name as it appears on the card,
             e.g., "John J Smith", 50 characters or less),
      valid?: max_length(50),
      type: String
    },

    address_line_1: {
      required?: true,
      doc: 'First address line, 255 characters or less',
      type: String
    },

    address_line_2: {
      doc: 'Second address line, 255 characters or less',
      type: String
    },

    city: {
      required?: true,
      doc: 'City, 40 characters or less',
      type: String
    },

    state: {
      required?: true,
      doc: 'State; must be a valid state name or 2-character abbreviation.',
      type: String
    },

    zip_code: {
      required?: true,
      doc: 'Zip code, 20 characters or less',
      type: String
    },

    country: {
      required?: true,
      doc: 'Country; must be a valid country name or abbreviation.',
      type: String
    },

    phone: {
      doc: 'Phone number, 40 characters or less',
      type: String
    },

    email: {
      doc: "Card holder's email address, 80 characters or less",
      type: String
    }
end
