module Zuora
  module Models
    class RatePlanChargeTier
      include DirtyValidAttr

      dirty_valid_attr :tier,
                       type: Numeric,
                       required?: true

      dirty_valid_attr :starting_unit,
                       type: Numeric

      dirty_valid_attr :ending_unit,
                       type: Numeric

      dirty_valid_attr :price,
                       type: Numeric,
                       required?: true

      dirty_valid_attr :price_format,
                       type: Numeric,
                       valid?: ->(s) { %w(FlatFee PerUnit).include? s }

      def initialize(attrs = {})
        set_attributes!(attrs)
      end
    end
  end
end
