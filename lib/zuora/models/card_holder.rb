# encoding: utf-8

module Zuora
  module Models
    class CardHolder
      include DirtyValidAttr

      dirty_valid_attr :card_holder_name,
                       type: String,
                       required?: true,
                       valid?: ->(s) { s.length <= 50 }

      dirty_valid_attr :address_line_1,
                       type: String,
                       required?: true,
                       valid?: ->(s) { s.length <= 255 }

      dirty_valid_attr :address_line_2,
                       type: String,
                       valid?: ->(s) { s.length <= 255 }

      dirty_valid_attr :city,
                       type: String,
                       required?: true,
                       valid?: ->(s) { s.length <= 40 }

      dirty_valid_attr :state,
                       type: String,
                       required?: true,
                       valid?: ->(s) { Zuora::STATE_ABBREVIATIONS.include? s }

      dirty_valid_attr :zip_code,
                       type: String,
                       required?: true,
                       valid?: ->(s) { s.length <= 20 }

      dirty_valid_attr :country,
                       type: String,
                       required?: true,
                       valid?: ->(s) { s.length <= 50 }

      dirty_valid_attr :phone,
                       type: String,
                       required?: true,
                       valid?: ->(s) { s.length <= 20 }

      dirty_valid_attr :email,
                       type: String,
                       required?: true

      def initialize(attrs = {})
        set_attributes!(attrs)
      end
    end
  end
end
