# frozen_string_literal: true

module Zuora
  module Calls
    class Delete < Hashie::Dash
      property :type, required: true
      property :ids, required: true

      def xml_builder
        raise 'Must be Enumerable' unless ids.respond_to? :each
        lambda do |builder|
          builder[:api].delete do
            builder[:api].type type
            ids.each do |id|
              builder[:api].ids id
            end
          end
        end
      end
    end
  end
end
