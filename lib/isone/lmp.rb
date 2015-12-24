module Isone
  class Lmp
    attr_accessor :lmps

    # @param [DateTime] date
    # @param [Integer] location_id
    def initialize(date, location_id)
      data = fetch_data(date, location_id)
      return unless data

      @lmps = data.map { |data| FiveMinLmp.new(data) }
    end

    private

    # @param [DateTime] date
    # @param [Integer] location_id
    def fetch_data(date, location_id)
      formatted_date = date.strftime('%Y%m%d')
      route = "fiveminutelmp/day/#{formatted_date}/location/#{location_id}.json"
      response = Isone::Connection.connection.get(route)
      json = JSON.parse(response.body)

      json['FiveMinLmps'].first.try(:[], 1)
    end
  end
end