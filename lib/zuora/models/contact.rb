# encoding: utf-8

module Zuora
  module Models
    class Contact
      include ActiveModel::Model

      ATTRIBUTES = :address_1,
                   :address_2,
                   :city,
                   :country,
                   :county,
                   :fax,
                   :first_name,
                   :home_phone,
                   :last_name,
                   :mobile_phone,
                   :nickname,
                   :other_phone,
                   :other_phone_type,
                   :personal_email,
                   :zip_code,
                   :state,
                   :tax_region,
                   :work_email,
                   :work_phone

      attr_accessor *ATTRIBUTES

      def attributes
        ATTRIBUTES
      end

      validates :first_name,
                :last_name,
                :country,
                :presence => true

      validates :first_name,
                :last_name,
                :length => { :maximum => 100 }

    end
  end
end