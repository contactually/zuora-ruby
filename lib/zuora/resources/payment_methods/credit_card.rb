# https://api.zuora.com/rest/v1/payment-methods/credit-cards

module Zuora
  module Resources
    module PaymentMethods
      module CreditCards
        def create!(client, credit_card)
          client.post '/rest/v1/credit_card/payment_account', credit_card.attributes
        end
      end
    end
  end
end