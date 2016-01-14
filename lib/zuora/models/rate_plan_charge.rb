# encoding: utf-8

module Zuora
  module Models
    class RatePlanCharge
      include DirtyValidAttr

      dirty_valid_attr :apply_discount_to,
                       type: String,
                       valid?: ->(s) { Zuora::DISCOUNT_TYPES.include? s }

      dirty_valid_attr :billing_period, type: String
      dirty_valid_attr :billing_period_alignment, type: String
      dirty_valid_attr :billing_timing, type: String
      dirty_valid_attr :bill_cycle_type, type: String
      dirty_valid_attr :bill_cycle_day, type: String
      dirty_valid_attr :description, type: String, valid?: ->(s) { s.length <= 500 }
      dirty_valid_attr :discount_amount, type: Numeric
      dirty_valid_attr :discount_percentage, type: Numeric
      dirty_valid_attr :discount_level, type: String, valid?: ->(s) { ZUORA::DISCOUNT_LEVELS.include? s }
      dirty_valid_attr :end_date_condition, type: String, valid?: -> (s) { ZUORA::END_DATE_CONDITIONS.include? s}
      dirty_valid_attr :included_units, type: Numeric
      dirty_valid_attr :list_price_base, type: String, valid?: ->(s) { ZUORA::LIST_PRICE_BASES.include? s }
      dirty_valid_attr :number, type: String, valid?: ->(s) { s.length <= 50 }
      dirty_valid_attr :number_of_periods, type: Numeric
      dirty_valid_attr :price, type: Numeric
      dirty_valid_attr :product_rate_plan_charge_id, type: String
      dirty_valid_attr :overage_price, type: Numeric
      dirty_valid_attr :overage_unused_units_credit_option, type: String
      dirty_valid_attr :price_change_option, type: String, valid?: ->(s) { ZUORA::PRICE_CHANGE_OPTIONS.include? s }
      dirty_valid_attr :price_increase_percentage, type: String
      dirty_valid_attr :rating_group, type: String
      dirty_valid_attr :quantity, type: Numeric, required?: true, valid?: ->(q) { q >= 0 }
      dirty_valid_attr :specific_billing_period, type: String
      dirty_valid_attr :specific_end_date, type: String
      dirty_valid_attr :tiers
      dirty_valid_attr :trigger_event, type: String, valid?: ->(t) { TRIGGER_EVENTS.include? t }
      dirty_valid_attr :trigger_date, type: Date
      dirty_valid_attr :unused_units_credit_rates, type: String
      dirty_valid_attr :up_to_periods_type, type: String, valid?: ->(u) { UP_TO_PERIODS.include? u }
      dirty_valid_attr :up_to_periods, type: String, required?: -> (model) { model.end_date_condition == 'Fixed_Period' }
      dirty_valid_attr :weekly_bill_cycle_day, type: String

      def initialize(attrs = {})
        set_attributes!(attrs)
      end
    end
  end
end
