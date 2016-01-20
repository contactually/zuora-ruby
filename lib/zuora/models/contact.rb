class Zuora::Models::Contact
  include SchemaModel

  schema :contact,
    address_1: {
      type: String,
      doc: 'First address line, 255 characters or less'
    },

    address_2: {
      type: String,
      doc: 'Second address line, 255 characters or less'
    },

    city: {
      type: String,
      doc: 'City, 40 characters or less'
    },

    country: {
      type: String,
      doc: 'Country; must be a valid country name or abbreviation.
      If using Z-Tax, be aware that it requires a country in the sold-to
      contact to calculate tax, and that a bill-to contact may be used if
      no sold-to contact is provided.',
      # TODO: validate against valid country codes
    },
    county: {
      doc: 'County; 32 characters or less. May optionally be used by
             Z-Tax to calculate county tax.'
    },

    fax: {
      type: String,
      doc: 'Fax phone number, 40 characters or less'
    },

    first_name: {
      doc: 'First name, 100 characters or less',
      type: String
    },

    home_phone: {
      doc: 'Home phone number, 40 characters or less',
      type: String
    },

    last_name: {
      doc: 'Last name, 100 characters or less',
      type: String
    },

    mobile_phone: {
      doc: 'Mobile phone number, 40 characters or less',
      type: String
    },

    nickname: {
      doc: 'Nickname for this contact',
      type: String
    },

    other_phone: {
      doc: 'Other phone number, 40 characters or less',
      type: String
    },

    other_phone_type: {
      doc: 'Possible values are: Work, Mobile, Home, Other.',
      type: String
    },

    personal_email: {
      doc: 'Personal email address, 80 characters or less',
      type: String
    },

    zip_code: {
      doc: 'Zip code, 20 characters or less',
      type: String
    },

    state: {
      doc: 'State; must be a valid state or province name or 2-character
            abbreviation. If using Z-Tax, be aware that Z-Tax requires a state
            (in the US) or province (in Canada) in this field for the
            sold-to contact to calculate tax, and that a bill-to contact may
            be used if no sold-to contact is provided.',
      type: String
    },

    tax_region: {
      doc: 'If using Z-Tax, a region string as optionally defined in
             your tax rules. Not required.',
      type: String
    },

    work_email: {
      type: String,
      doc: 'Work email address, 80 characters or less' },

    work_phone: {
      type: String,
      doc: 'Work phone number, 40 characters or less'
    }
end
