# encoding: utf-8

module Zuora
  class Contact
    include ActiveModel::Model

    attr_accessor :address_1
    attr_accessor :address_2
    attr_accessor :city
    attr_accessor :country
    attr_accessor :county
    attr_accessor :fax
    attr_accessor :first_name
    validates_presence_of :first_name
    attr_accessor :home_phone
    attr_accessor :last_name
    validates_presence_of :last_name
    attr_accessor :mobile_phone
    attr_accessor :nickname
    attr_accessor :other_phone
    attr_accessor :other_phone_type
    attr_accessor :personal_email
    attr_accessor :zip_code
    attr_accessor :state
    attr_accessor :tax_region
    attr_accessor :work_email
    attr_accessor :work_phone

  end
end