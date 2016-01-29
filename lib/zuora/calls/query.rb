module Zuora
  module Calls
    class Query < Hashie::Dash
      def initialize(query_string)
        @query_string = query_string
      end

      def xml_builder
        lambda do |builder|
          builder[:api].query { builder[:api].queryString(@query_string) }
        end
      end
    end
  end
end
