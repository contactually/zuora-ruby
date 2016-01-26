module Zuora
  module Soap
    class Object < Hash
      include Hashie::Extensions::MethodAccess
    end
  end
end
