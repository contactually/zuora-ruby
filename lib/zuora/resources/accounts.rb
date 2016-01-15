module Zuora
  module Resources
    module Accounts
      RESOURCE_URI = '/rest/v1/accounts'

      def self.request!(verb, uri, args)
        client, model, serializer = args
        client.send verb, uri, serializer.serialize(model)
      end

      def self.create!(*args)
        request! :post, RESOURCE_URI, args
      end

      def self.update!(*args)
        request! :put, RESOURCE_URI, args
      end
    end
  end
end
