# Todo

```ruby
username = 'your@username.com'
password = 'super_secure_password'

client = Zuora::Client.new(username, password, true)

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

# Create an account

client.post '/rest/v1/accounts', a.attributes

=> 

# Le response

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