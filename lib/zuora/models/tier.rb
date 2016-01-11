module Zuora
  module Models
    class Tier
      include ActiveModel::Model

      ATTRIBUTES = :tier,
        :starting_unit,
        :ending_unit,
        :price,
        :price_format

      attr_accessor *ATTRIBUTES

      def attributes
        ATTRIBUTES
      end

      validates :tier,
                :price,
                :presence => true

      validates :price_format,
                :inclusion => { :in => %w(FlatFee PerUnit)},
                :allow_nil => true
    end
  end
end