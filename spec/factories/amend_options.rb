# frozen_string_literal: true

FactoryGirl.define do
  factory :amend_options, class: Hash do
    generate_invoice true
    process_payments true

    initialize_with { attributes }
  end
end
