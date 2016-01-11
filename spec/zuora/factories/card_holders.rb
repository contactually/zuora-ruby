FactoryGirl.define do
  factory :card_holder, :class => Zuora::Models::CardHolder do
    card_holder_name 'First Last'
    address_line_1 '123 Main St'
    city 'Dayton'
    state 'OH'
    country 'USA'
    phone '301-555-1212'
    email 'abc@abc.com'
    zip_code'12345'
  end
end