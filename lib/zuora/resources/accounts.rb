module Zuora
  module Resources
    module Accounts
      def self.create!(client, model, serializer = Zuora::Serializers::Noop)
        Zuora::Resources.with_valid model do |model|
          client.post '/rest/v1/accounts', serializer.serialize(model)
        end
      end

      def self.update!(client, model, serializer = Zuora::Serializers::Noop)
        Zuora::Resources.with_valid model do |model|
          client.post '/rest/v1/accounts', serializer.serialize(model)
        end
      end
    end
  end
end