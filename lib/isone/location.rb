module Isone
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