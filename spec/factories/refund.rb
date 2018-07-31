# frozen_string_literal: true

FactoryGirl.define do
  factory :refund, class: Hash do
    amount 5
    comment 'Five dollas back'
    type 'Electronic'
    payment_id '2c92c0945239b44f01523de2ce0a6e7b'

    initialize_with { attributes }
  end
end
