# encoding: utf-8

module Zuora
  module Models
    class RatePlanCharge
      include DirtyValidAttr

      dirty_valid_attr :apply_discount_to,
        type: String,
        valid?: one_of(Zuora::DISCOUNT_TYPES)

      dirty_valid_attr :billing_period,
        type: String

      dirty_valid_attr :billing_period_alignment,
        type: String

      dirty_valid_attr :billing_timing,
        type: String

      dirty_valid_attr :bill_cycle_type,
        type: String

      dirty_valid_attr :bill_cycle_day,
        type: String

      dirty_valid_attr :description,
        type: String,
        valid?: max_length(500)

      dirty_valid_attr :discount_amount,
        type: Numeric

      dirty_valid_attr :discount_percentage,
        type: Numeric

      dirty_valid_attr :discount_level,
        type: String,
        valid?: one_of(Zuora::DISCOUNT_LEVELS)

      dirty_valid_attr :end_date_condition,
        type: String,
        valid?: one_of(Zuora::END_DATE_CONDITIONS)

      dirty_valid_attr :included_units,
        type: Numeric

      dirty_valid_attr :list_price_base,
        type: String,
        valid?: one_of(Zuora::LIST_PRICE_BASES)

      dirty_valid_attr :number,
        type: String,
        valid?: max_length(50)

      dirty_valid_attr :number_of_periods,
        type: Numeric

      dirty_valid_attr :price,
        type: Numeric

      dirty_valid_attr :product_rate_plan_charge_id,
        type: String

      dirty_valid_attr :overage_price,
        type: Numeric

      dirty_valid_attr :overage_unused_units_credit_option,
        type: String

      dirty_valid_attr :price_change_option,
        type: String,
        valid?: one_of(Zuora::PRICE_CHANGE_OPTIONS)

      dirty_valid_attr :price_increase_percentage,
        type: String

      dirty_valid_attr :rating_group,
        type: String

      dirty_valid_attr :quantity,
        type: Numeric,
        required?: true,
        valid?: min(0)

      dirty_valid_attr :specific_billing_period,
        type: String

      dirty_valid_attr :specific_end_date,
        type: String

      dirty_valid_attr :tiers

      dirty_valid_attr :trigger_event,
        type: String,
        valid?: one_of(TRIGGER_EVENTS)

      dirty_valid_attr :trigger_date,
        type: Date

      dirty_valid_attr :unused_units_credit_rates,
        type: String

      dirty_valid_attr :up_to_periods_type,
        type: String,
        valid?: one_of(UP_TO_PERIODS)

      dirty_valid_attr :up_to_periods,
        type: String,
        required?: other_attr_eq(:end_date_condition,
          'Fixed_Period')

      dirty_valid_attr :weekly_bill_cycle_day,
        type: String

      alias_method :initialize, :initialize_attributes!
    end
  end
end
