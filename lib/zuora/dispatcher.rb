# frozen_string_literal: true

module Zuora
  module Dispatcher
    # Maps a SOAP call name and args to its corresponding class.

    class << self
      def create
        Zuora::Calls::Create
      end

      def update
        Zuora::Calls::Update
      end

      def login
        Zuora::Calls::Login
      end

      def subscribe
        Zuora::Calls::Subscribe
      end

      def amend
        Zuora::Calls::Amend
      end

      def query
        Zuora::Calls::Query
      end

      def query_more
        Zuora::Calls::QueryMore
      end

      def delete
        Zuora::Calls::Delete
      end

      def generate
        Zuora::Calls::Generate
      end

      def method_missing
        raise "Unknown SOAP API call name: #{call_name}.
              Must be one of :create, :update, :login,
              subscribe, :amend, or :delete."
      end
    end
  end
end
