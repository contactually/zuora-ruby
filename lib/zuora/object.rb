# frozen_string_literal: true

module Zuora
  class Object < Hash
    include Hashie::Extensions::MethodAccess
  end
end
