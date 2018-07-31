# frozen_string_literal: true

module Zuora
  module Calls
    class Update < Zuora::Calls::Upsert
      def call_name
        :update
      end
    end
  end
end
