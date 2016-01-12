require_relative '../models/utils/dirty'
require 'active_support'

module Zuora
  module Models
    class Contact
      include ActiveModel::Validations
      include ActiveModel::Dirty
      include DirtyAttrAccessor

      dirty_attr_accessor :address_1,
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

      validates :first_name,
                :last_name,
                :country,
                presence: true

      validates :first_name,
                :last_name,
                length: { maximum: 100 }

      def initialize(attrs = {})
        attrs.each do |attr, val|
          instance_variable_set "@#{attr}", val
        end
      end
    end
  end
end
