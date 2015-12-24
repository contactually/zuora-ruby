# encoding: utf-8
module Isone
  # A class to house the logic related to Five Minute Locational Marginal
  # Pricing.
  class FiveMinLmp
    attr_accessor :begin_date,
                  :location,
                  :lmp_total,
                  :energy_component,
                  :congestion_component,
                  :loss_component

    # @param [Hash] data
    def initialize(data)
      @begin_date = DateTime.parse(data['BeginDate'])
      @location = Isone::Location.new(data['Location'])

      attrs = %w(LmpTotal EnergyComponent CongestionComponent LossComponent)
      attrs.each do |key|
        instance_variable_set("@#{key.underscore}", data[key])
      end
    end
  end
end
