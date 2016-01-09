# encoding: utf-8

module Zuora
  module Models
    class CardHolder
      include ActiveModel::Model
      include ActiveModel::Serialization

      ATTRIBUTES = :card_holder_name,
                   :address_line_1,
                   :address_line_2,
                   :city,
                   :state,
                   :zip_code,
                   :country,
                   :phone,
                   :email

      attr_accessor *ATTRIBUTES

      validates :card_holder_name,
                :address_line_1,
                :city,
                :state,
                :zip_code,
                :country,
                :presence => true

      validates :card_holder_name,
                :length => { :maximum => 50 }

      validates :address_line_1,
                :length => { :maximum => 255 }

      validates :address_line_2,
                :length => { :maximum => 255 },
                :allow_nil => true

      validates :city,
                :length => { :maximum => 40 }

      validates :state,
                :inclusion => { :in => Zuora::STATE_ABBREVIATIONS }

      validates :zip_code,
                :length => { :maximum => 20 }

      validates :phone,
                :length => { :maximum => 20 },
                :allow_nil => true

      validates :email,
                :length => { :maximum => 80 },
                :allow_nil => true
    end
  end
end