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
        type: String,
        valid?: one_of(%w(FlatFee PerUnit))

      alias_method :initialize, :initialize_attributes!
    end
  end
end
