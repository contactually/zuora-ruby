module Zuora
  module Models
    class Contact
      include DirtyValidAttr

      dirty_valid_attr :address_1,
                       type: String,
                       required?: true

      dirty_valid_attr :address_2,
                       type: String

      dirty_valid_attr :city,
                       type: String

      dirty_valid_attr :country,
                       type: String

      dirty_valid_attr :county,
                       type: String

      dirty_valid_attr :fax,
                       type: String

      dirty_valid_attr :home_phone,
                       type: String

      dirty_valid_attr :first_name,
                       type: String,
                       required?: true,
                       valid: ->(s){ s.length < 100 }

      dirty_valid_attr :last_name,
                       type: String,
                       required?: true,
                       valid: ->(s){ s.length < 100 }

      dirty_valid_attr :mobile_phone,
                       type: String

      dirty_valid_attr :nickname,
                       type: String

      dirty_valid_attr :other_phone,
                       type: String

      dirty_valid_attr :other_phone_type,
                       type: String

      dirty_valid_attr :personal_email,
                       type: String

      dirty_valid_attr :state,
                       type: String

      dirty_valid_attr :tax_region,
                       type: String

      dirty_valid_attr :work_email,
                       type: String

      dirty_valid_attr :work_phone,
                       type: String

      dirty_valid_attr :zip_code,
                       type: String


      def initialize(attrs = {})
        set_attributes!(attrs)
      end
    end
  end
end
