[![Circle CI](https://circleci.com/gh/contactually/zuora-ruby.svg?style=shield&circle-token=808be5d625e91e331bedb37a2fe94412bb3bc15e)](https://circleci.com/gh/contactually/zuora-ruby)
[![Code Climate](https://codeclimate.com/repos/569444dfa3d810003a00313f/badges/416bae00acf65d690efe/gpa.svg)](https://codeclimate.com/repos/569444dfa3d810003a00313f/feed)
[![Test Coverage](https://codeclimate.com/repos/569444dfa3d810003a00313f/badges/416bae00acf65d690efe/coverage.svg)](https://codeclimate.com/repos/569444dfa3d810003a00313f/coverage)

# Zuora REST API: Ruby Client

This library implements a Ruby client wrapping Zuora's REST API.
- **Validations** (via `activemodel`)
- **HTTP** (via `faraday`)
- **Serialization**: To/from Ruby / JSON

## Quickstart
```ruby
# Connect
client = Zuora::Client.new(username, password) 
# Create a model
account = Zuora::Models::Account.new(...)
# Validate
account.valid? # true or false, check account.errors if false
# Select a serializer (snake_case -> lowerCamelCase)
serializer = Zuora::Serializers::Attribute
# Low level HTTP API
client.get('/rest/v1/accounts', serializer.serialze account)
# High Level Resource API 
Zuora::Resources::Account.create! client, account, serializer
```
## Key Features & Concepts 
1. ***Client:*** Create a client by providing username and password.
This authenticates and stores the returned session cookie 
used in subsequent requests. An optional third, truthy value enables Sandbox instead of production mode.

2. ***HTTP:***
Use `client.<get|post|put>(url, params)` to make HTTP requests via the authenticated client. Request and response body will be converted to/from Ruby via `farraday_middleware`. 

3. ***Models:***  Ruby interface for constructing valid Zuora objects.
  - `account = Zuora::Models::Account.new(:attribute => 'name')`
  - `account.valid?`  a boolean indicating validity
  - `account.errors`  a hash of error message(s)
  - `account.attributes` an array of attribute names

4. **Serializers:** Recursive data transformations for mapping between formats; a Ruby -> JSON serializer is included; `snake_case` attributes are transformed into JSON `lowerCamelCase` recursively in a nested structure.
  - ex. `Zuora::Serializers::Attribute.serialize account` 
  

5. **Resources:** Wraps Zuora REST API endpoints. Hand a valid model and (optionally) a serializer to a Resource to trigger a request. Request will be made for valid models only. An exception will be raised if the model is invalid. Otherwise, a `Farraday::Response` object will be returned (responding to `.status`, `.headers`, and `.body`).

6. **Factories:** Factories are set up for easily constructing Zuora requests in development (via `factory_girl`) 
```ruby
account = create :account, :credit_card => create(:credit_card),
                           :sold_to_contact => create(:contact),
                           :bill_to_contact => create(:contact)
                           
account.valid? # => true
```
7. **Test coverage:** Unit and integration specs coverage via `rspec`. Coming soon: HTTP response caching (using `VCR`)

## Models
Models implement (recursive, nested) Zuora validations using `ActiveModel::Model` and soon, dirty attribute tracking via `ActiveModel::Dirty`
* Account
* CardHolder
* Contact
* PaymentMethod::CreditCard
* RatePlan
* RatePlanCharge
* Subscription
* Tier

## Resources 
In module  `Zuora::Resources::` 
* `Account.create!` **[working]**
* `Account.update!` [in progress]
* `Subscription.create!` [in progress]
* `Subscription.update!` [in progress]
* `Subscription.cancel!` [in progress]
* `PaymentMethod.update!` [in progress]

## Examples
### Creating an Account

```ruby
username = 'your@username.com'
password = 'super_secure_password'

client = Zuora::Client.new(username, password, true) # true for sandbox

account = Zuora::Models::Account.new(
  :name => 'Abc',
  :auto_pay => true,
  :currency => 'USD',
  :bill_cycle_day => '0',
  :payment_term => 'Net 30',
  :bill_to_contact => Zuora::Models::Contact.new(
    :first_name => 'Abc',
    :last_name => 'Def',
    :address_1 => '123 Main St',
    :city => 'Palm Springs',
    :state => 'FL',
    :zip_code => '90210',
    :country => 'US'
  ),
  :sold_to_contact => Zuora::Models::Contact.new(
    :first_name => 'Abc',
    :last_name => 'Def',
    :country => 'US'
  ),
  :credit_card => Zuora::Models::PaymentMethod.new(
    :card_type => 'Visa',
    :card_number => '4111111111111111',
    :expiration_month => '03',
    :expiration_year => '2017',
    :security_code => '122',
  )
)

# Create an account in one of two ways:

serializer = Zuora::Serializers::Attribute

# Using the low-level API exposed by `Client`
response = client.post('/rest/v1/accounts', serializer.serialize accont)

# or using the higher-level resource API
response = Zuora::Resources::Accounts.create!(client, account, serializer)

# Le response

pp response

#<Faraday::Response:0x007f8033b05f08
 @env=
  #<struct Faraday::Env
   method=:post,
   body=
    {"success"=>true,
     "accountId"=>"2c92c0fa521b466c0152250822741a71",
     "accountNumber"=>"A00000038",
     "paymentMethodId"=>"2c92c0fa521b466c0152250829c81a7b"},
   url=#<URI::HTTPS https://apisandbox-api.zuora.com/rest/v1/accounts>,
   request=
    #<struct Faraday::RequestOptions
     params_encoder=nil,
     proxy=nil,
     bind=nil,
     timeout=nil,
     open_timeout=nil,
     boundary=nil,
     oauth=nil>,
   request_headers=
    {"User-Agent"=>"Faraday v0.9.2",
     "Content-Type"=>"application/json",
     "Cookie"=>
      "ZSession=LBToVw72ZCAQLjdZ9Ksj8rx2BlP3NbgmMYwCzuf_slSJqIhMbJjdQ1T-4otbdfjUOImQ_XJOCbJgdCd7jHmGsnnJyG49NyRkI7FVKOukVQtdJssJ5n1xAXJeVjxj3qj97iiIZp697v3G2w86iCTN6kWycUlSVezBElbC8_EhScbx8YmaP4QJxXRIFHHdOQPq3IN-9ezk21Cpq3fdXn6s0fIPMU7NUFj7-kD4dcYNBAyd7i2fJVAIV31mXNBH2MuU;"},
   ssl=
    #<struct Faraday::SSLOptions
     verify=false,
     ca_file=nil,
     ca_path=nil,
     verify_mode=nil,
     cert_store=nil,
     client_cert=nil,
     client_key=nil,
     certificate=nil,
     private_key=nil,
     verify_depth=nil,
     version=nil>,
   parallel_manager=nil,
   params=nil,
   response=#<Faraday::Response:0x007f8033b05f08 ...>,
   response_headers=
    {"server"=>"Zuora App",
     "content-type"=>"application/json;charset=utf-8",
     "expires"=>"Sat, 09 Jan 2016 06:17:18 GMT",
     "cache-control"=>"max-age=0, no-cache, no-store",
     "pragma"=>"no-cache",
     "date"=>"Sat, 09 Jan 2016 06:17:18 GMT",
     "content-length"=>"165",
     "connection"=>"close",
     "set-cookie"=>
      "ZSession=dOz9WgdPQbb9J9wzwhuR_t1j9feD4dYBUEZ_sjK6pS9KAaJtPdKN-jAivNELsaANWMJrvHW_1eLxT7XqzjLVBJKzLDJT7_0ucvzcrwNcwMW8mUGpeUhQQu_h2HzNH1kZjc1HX6pfw-BH66BafLemLIdqL75ifmglk8YuTOf_wTg54GsovkrgJCAp9zferw6pYHkZoQUXyH7zmUmmWvMAZ1ZVamhLOf1P3FrrHaw6eIiUj0ehlKvrtxB-GHIgYxh6; Path=/; Secure; HttpOnly"},
   status=200>,
 @on_complete_callbacks=[]>
```
# Changelog
* **[0.1.0] Initial release** 
# Roadmap
* **[0.1.1] Additional resources** See Resource list above
* **[0.2.0] Add VCR** Fast, deterministic HTTP requests and responses
* **[0.3.0] Dirty attribute tracking:** only serialize attributes that have been explicitly set. Currently, unset attributes are sent as `nil` which might override Zuora defaults.

# Commit rights
Anyone who has a patch accepted may request commit rights. Please do so inside the pull request post-merge.

# Contributors
* [John Gerhardt](https://github.com/jws2g)
* [Shaun Robinson](https://github.com/env)

# License
MIT License. Copyright 2016 Contactually, Inc. http://contactually.com
