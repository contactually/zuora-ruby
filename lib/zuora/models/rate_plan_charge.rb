# encoding: utf-8

module Zuora
  module Models
    class RatePlanCharge
      include ActiveModel::Model

      ATTRIBUTES = :product_rate_plan_charge_id,
                   :number,
                   :description,
                   :price,
                   :tiers,
                   :included_units,
                   :overage_price,
                   :list_price_base,
                   :quantity,
                   :discounted_amount,
                   :discount_percentage,
                   :apply_discount_to,
                   :discount_level,
                   :trigger_event,
                   :trigger_date,
                   :end_date_condition,
                   :up_to_periods_type,
                   :up_to_periods,
                   :specific_end_date,
                   :billing_period,
                   :specific_billing_period,
                   :billing_period_alignment,
                   :billing_timing,
                   :rating_group,
                   :bill_cycle_type,
                   :bill_cycle_day,
                   :number_of_periods,
                   :overage_unused_units_credit_option,
                   :unused_units_credit_rates,
                   :price_change_option,
                   :price_increase_percentage,
                   :weekly_bill_cycle_day

      attr_accessor *ATTRIBUTES

      def attributes
        ATTRIBUTES
      end

      validates :product_rate_plan_id,
                :presence => true

      validates :number,
                :length => { :maximum => 50 }

      validates :description,
                :length => { :maximum => 500 }

    end
  end
end