[![Circle CI](https://circleci.com/gh/contactually/zuora-ruby.svg?style=shield&circle-token=808be5d625e91e331bedb37a2fe94412bb3bc15e)](https://circleci.com/gh/contactually/zuora-ruby)
[![Code Climate](https://codeclimate.com/repos/569444dfa3d810003a00313f/badges/416bae00acf65d690efe/gpa.svg)](https://codeclimate.com/repos/569444dfa3d810003a00313f/feed)
[![Test Coverage](https://codeclimate.com/repos/569444dfa3d810003a00313f/badges/416bae00acf65d690efe/coverage.svg)](https://codeclimate.com/repos/569444dfa3d810003a00313f/coverage)

# Zuora SOAP API Client

## Features
* HTTP client to Zuora SOAP API
* Authentication and session storage
* SOAP XML request constructors from Ruby data
* Light validation of top-level forms; field-level validation delegated to Zuora's responses.

## Usage


### Client

Create a client
```ruby
client = Zuora::Client.new(<username>, <password>)
```


Execute a SOAP request. Currently only  `:create` and `:subscribe` are supported

#### Create Example

 ```ruby
response = client.call! :create,
  type: :BillRun,
  objects: [{ 
    invoice_date: '2016-03-01',
    target_date: '2016-03-01'
  }]
    
```

This would generate SOAP XML, make, and return an authenticated SOAP request.

```xml
    <?xml version="1.0"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://api.zuora.com/" xmlns:ns2="http://object.api.zuora.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Header>
        <ns1:SessionHeader>
          <ns1:session><!-- SESSION TOKEN HERE --></ns1:session>
        </ns1:SessionHeader>
      </soapenv:Header>
      <soapenv:Body>
        <ns1:create>
          <ns1:zObjects xsi:type="ns2:BillRun">
            <ns2:InvoiceDate>2016-03-01</ns2:InvoiceDate>
            <ns2:TargetDate>2016-03-01</ns2:TargetDate>
          </ns1:zObjects>
        </ns1:create>
      </soapenv:Body>
    </soapenv:Envelope>
```

A response object is returned, having status and body

```ruby
response.body
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <ns1:createResponse xmlns:ns1="http://api.zuora.com/">
      <ns1:result>
        <ns1:Id>2c92c0f9526913e301526a7863df4647</ns1:Id>
        <ns1:Success>true</ns1:Success>
      </ns1:result>
    </ns1:createResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

This XML body, in turn, could be parsed with Nokogiri for further work.

```ruby
response_xml = Nokogiri::XML(response.body)
success = response_xml.xpath(
 '/soapenv/Envelope/soapenv:Body/ns1:createResponse/ns1:result/ns1:Success'
 ).text == 'true'
```


#### Subscribe Example
Subscribe is a very large call that involves a lot of data. See the integration spec `spec/zuora/integration/subscription_spec` for full example

 ```ruby
response = client.call! :subscribe, 
  account: {...},
  payment_method: {...},
  bill_to_contact: {...},
  sold_to_contact: {...},
  subscription: {...},
  rate_plan: {...}

```

# Changelog
* **[0.1.0 - 2016-01-12]** Initial release 
* **[0.2.0] - 2016-01-14]** Models
     - Refactored client to clarify logic 
     - Replaces `ActiveRecord::Model` and `::Validations` with a base module that provides powerful and extensible facilities for modeling remote resources in Ruby. 
       * required attributes, coercions, validations, type checking
       * dirty attribute tracking
       * extensible predicate library
     - Implements fine-grained validations per Zuora spec
     - Removes invalid model state paradigm used via `ActiveModel` in version 0.1.0.
     -  A model now performs its validations on `.new`, and will raise a detailed exception on mistyped, invalid or uncoercable data.
     - Adds VCR for mocking out HTTP requests
     - Adds integration specs for `Subscribe` `create!` and `update!` and `Account` `create!` and `update!`

* **[0.3.0 2016-1-28]** Focus on SOAP API, simpify client library feature set
    - Implement SOAP API Client; it provides fuller functionality than REST 
    - Focus on constructing + composing hash-like Ruby objects into XML SOAP requests 
    - No object-level validations; relies on Zuora's own responses
    - See integration specs for full interface
    
# Commit rights
Anyone who has a patch accepted may request commit rights. Please do so inside the pull request post-merge.

# Contributors
* [John Gerhardt](https://github.com/jwg2s)
* [Shaun Robinson](https://github.com/env)

# License
MIT License. Copyright 2016 Contactually, Inc. http://contactually.com
