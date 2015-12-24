# encoding: utf-8
module Isone
  # Houses logic related to a particular location within the ISO NE node
  # network.
  class Location
    attr_accessor :id, :type, :name

    # @param [Hash] data
    def initialize(data)
      @id = data['@LocId']
      @type = data['@LocType']
      @name = data['$']
    end
  end
end
