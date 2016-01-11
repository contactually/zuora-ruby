module Zuora
  module Resources
    module Accounts
      def self.create!(client, account)
        client.post '/rest/v1/accounts', account.attributes
      end

      def self.update!(client, account)
        client.put '/rest/v1/accounts', account.attributes
      end
    end
  end
end