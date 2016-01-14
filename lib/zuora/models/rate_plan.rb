# encoding: utf-8

module Zuora
  module Models
    class RatePlan
      include DirtyValidAttr

      dirty_valid_attr :product_rate_plan_id, type: String, required?: true
      dirty_valid_attr :charge_overrides

      alias_method :initialize, :initialize_attributes!
    end
  end
end
