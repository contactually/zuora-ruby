module Zuora
  module Resources
    module Accounts
      RESOURCE_URI = '/rest/v1/accounts'

      def self.create!(client, model, serializer = Zuora::Serializers::Noop)
        Zuora::Resources.with_valid model do |mod|
          client.post RESOURCE_URI, serializer.serialize(mod)
        end
      end

      def self.update!(client, model, serializer = Zuora::Serializers::Noop)
        Zuora::Resources.with_valid model do |mod|
          client.post RESOURCE_URI, serializer.serialize(mod)
        end
      end
    end
  end
end
