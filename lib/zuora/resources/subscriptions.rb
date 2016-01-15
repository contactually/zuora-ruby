# encoding: utf-8

module Zuora
  module Resources
    module Subscriptions
      RESOURCE_URI = '/rest/v1/subscriptions'

      def self.create!(client, model, serializer = Zuora::Serializers::Noop)
        client.post RESOURCE_URI, serializer.serialize(model)
      end

      def self.update!(client, model, serializer = Zuora::Serializers::Noop)
        client.post RESOURCE_URI, serializer.serialize(model)
      end
    end
  end
end
