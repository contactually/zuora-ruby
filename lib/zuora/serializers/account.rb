module Zuora
  module Serializers
    class AccountSerializer < ActiveModel::Serializer
      attributes *Zuora::Account::ATTRIBUTES

      has_one :contact, :key => :bill_to_contact
      has_one :sold_to_contact, :key => :sold_to_contact
    end
  end
end