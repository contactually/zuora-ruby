# encoding: utf-8
module Zuora
  module Resources
    module PaymentMethods
      module CreditCards
        RESOURCE_URI = '/rest/v1/credit_card/payment_account'

        # Validates a model, and throws if invalid.
        # Otherwise, makes an HTTP request, creating a credit card
        # payment account.

        # https://api.zuora.com/rest/v1/payment-methods/credit-cards

        # @param [Zuora::Client] client
        # @param [Zuora::Model::PaymentMethod] model: the credit card
        # @param [Class] serializer: any object supporting .serialze(data)
        # @return [Faraday::Response]
        def self.create!(client, model, serializer = Zuora::Serializers::Noop)
          Zuora::Resources.with_valid model do |model|
            client.post RESOURCE_URI, serializer.serialize(model)
          end
        end
      end
    end
  end
end