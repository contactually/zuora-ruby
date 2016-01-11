# encoding: utf-8

module Zuora
  module Models
    class RatePlan
      include ActiveModel::Model

      ATTRIBUTES = :product_rate_plan_id,
                   :charge_overrides

      attr_accessor *ATTRIBUTES

      def attributes
        ATTRIBUTES
      end

      validates :product_rate_plan_id,
                :presence => true

    end
  end
end