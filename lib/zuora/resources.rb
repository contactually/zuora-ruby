module Zuora
  module Resources
    InvalidModel = Class.new(StandardError)

    def self.with_valid(model, &block)
      if model.valid?
        block.call model
      else
        fail InvalidModel, model
      end
    end
  end
end

require_relative 'resources/accounts'
require_relative 'resources/payment_methods'
require_relative 'resources/subscriptions'
