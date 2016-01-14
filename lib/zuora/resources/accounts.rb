module Zuora
  module Resources
    module Accounts
      RESOURCE_URI = '/rest/v1/accounts'

      def self.create!(client, model, serializer = Zuora::Serializers::Noop)
        client.post RESOURCE_URI, serializer.serialize(model)
      end

      def self.update!(client, model, serializer = Zuora::Serializers::Noop)
        client.post RESOURCE_URI, serializer.serialize(model)
      end
    end
  end
end
