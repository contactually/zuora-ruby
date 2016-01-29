FactoryGirl.define do
  factory :bill_run, class: Hash do
    target_date '2016-03-01'
    invoice_date '2016-03-01'

    initialize_with { attributes }
  end
end
