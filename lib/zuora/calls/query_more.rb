# frozen_string_literal: true

module Zuora
  module Calls
    class QueryMore < Hashie::Dash
      # After executing a query, often time a query_locator is returned when
      # there are more records than Zuora can respond with in a single response.
      # The default batch size is 2000.  You can use a combination of query and
      # query_more calls to get large quantities of data.
      # @param [String] query_locator
      # @return [Zuora::Calls:Query]
      def initialize(query_locator)
        @query_locator = query_locator
      end

      # @return [Callable]
      def xml_builder
        lambda do |builder|
          builder[:api].queryMore { builder[:api].queryLocator(@query_locator) }
        end
      end
    end
  end
end
