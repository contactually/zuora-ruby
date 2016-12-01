[![Circle CI](https://circleci.com/gh/contactually/zuora-ruby.svg?style=shield&circle-token=808be5d625e91e331bedb37a2fe94412bb3bc15e)](https://circleci.com/gh/contactually/zuora-ruby)
[![Code Climate](https://codeclimate.com/github/contactually/zuora-ruby/badges/gpa.svg)](https://codeclimate.com/github/contactually/zuora-ruby)
[![Test Coverage](https://codeclimate.com/github/contactually/zuora-ruby/badges/coverage.svg)](https://codeclimate.com/github/contactually/zuora-ruby/coverage)

# Zuora SOAP and REST API Client

## Features
* HTTP client to Zuora SOAP and REST API
* Authentication and session storage
* SOAP XML request constructors from Ruby data
* Light validation of top-level forms; field-level validation delegated to Zuora's responses.

## Usage

### Client

Creating a client to both SOAP and REST API is easy:
```ruby
client = Zuora::Client.new(<username>, <password>)
```
This will cache the login credentials (don't worry, they're excluded from being logged). Upon using methods requiring SOAP or REST client, that client is lazily authenticated against the respective API. The resulting session is cached and used in subsequent requests.

It's possible to use the clients directly:
```ruby
soap_client = Zuora::Soap::Client.new(<username>, <password>)
rest_client = Zuora::Rest::Client.new(<username>, <password>)
```

### SOAP Calls
Soap calls are made using the `call!` method. The argument structure varies depending on the SOAP method. See specs for exact interfaces.

```ruby
client.call! :create, type: :Invoice, objects: [{...}, {...}]
client.call! :update, type: :Invoice, objects: [{...}, {...}]
client.call! :delete, type: :Invoice, ids: [{...}, {...}]
client.call! :generate, objects: [{...}, {...}]
client.call! :query, "SELECT Notes FROM Account WHERE id = '1'"
client.call! :query, [:notes], :Account, {id: 1}
client.call! :amend, 
  amendments: {...}, 
  amend_options: {...}, 
  preview_options: {} 
client.call! :subscribe,
  payment_method: {...}
  bill_to_contact: {...}
  sold_to_contact: {...}
  subscribe_options: {...}
  subscription: {...}
  rate_plan: {...}
```

SOAP requests return a `Zuora::Response` object that parses the XML response into Ruby data via the `#to_h` method. The raw request is available via the `#raw` method.

### REST
```ruby
client.get('/rest/v1/accounts/1')
client.delete('/rest/v1/accounts/1')
client.post('/rest/v1/accounts', notes: 'hello')
client.put('/rest/v1/accounts/1', id: 1, notes: 'world')
```

REST requests return a Farraday::Response object, which has a `body` and `status`. See [Farraday](https://github.com/lostisland/faraday) docs for details. 

#### SOAP Create Example

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
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:api="http://api.zuora.com/" xmlns:obj="http://object.api.zuora.com/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <soapenv:Header>
        <api:SessionHeader>
          <api:session><!-- SESSION TOKEN HERE --></api:session>
        </api:SessionHeader>
      </soapenv:Header>
      <soapenv:Body>
        <api:create>
          <api:zObjects xsi:type="obj:BillRun">
            <obj:InvoiceDate>2016-03-01</obj:InvoiceDate>
            <obj:TargetDate>2016-03-01</obj:TargetDate>
          </api:zObjects>
        </api:create>
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
    <api:createResponse xmlns:api="http://api.zuora.com/">
      <api:result>
        <api:Id>2c92c0f9526913e301526a7863df4647</api:Id>
        <api:Success>true</api:Success>
      </api:result>
    </api:createResponse>
  </soapenv:Body>
</soapenv:Envelope>
```

This XML body, in turn, could be parsed with Nokogiri for further work.

```ruby
response_xml = Nokogiri::XML(response.body)
success = response_xml.xpath(
 '/soapenv/Envelope/soapenv:Body/api:createResponse/api:result/api:Success'
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
* **[0.5.0 2016-05-12]** Uniform REST and SOAP client
  - Generalizes the client to work for both REST and SOAP APIs. In practice, both are useful to access the gamut  of Zuora's operations. SOAP is better for fine-grained control, while REST is larger-grained and shifts the burden of transactions onto Zuora for certain operations.
  - Adds integration specs to cover REST GET, POST, PUT, DELETE
  - Errors are thrown for unsuccessful responses
  - Prevents credentials from being logged
  - SOAP Query call: now with arity-1 and arity-3 versions, pass a ZOQL query as string or as data. See docs and specs for details.
  - Add support for queryMore for result sets greater than 2000 in size

* **[0.4.0 2016-02-10]** Improves interface and feedback loop between developer and Zuora servers.
  - Allow flexible submission of parameters to the API.  Let Zuora's API handle validation instead of performing in the client.
  - Adds integration specs to cover base functionality
  - Adds exception raising to match servier-side exceptions such as missing required fields, invalid data, etc.

* **[0.3.0 2016-1-28]** Focus on SOAP API, simplify client library feature set
    - Implement SOAP API Client; it provides fuller functionality than REST 
    - Focus on constructing + composing hash-like Ruby objects into XML SOAP requests 
    - No object-level validations; relies on Zuora's own responses
    - See integration specs for full interface

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

* **[0.1.0 - 2016-01-12]** Initial release 

# Commit rights
Anyone who has a patch accepted may request commit rights. Please do so inside the pull request post-merge.

# Contributors
* [John Gerhardt](https://github.com/jwg2s)
* [Shaun Robinson](https://github.com/env)

# License
MIT License. Copyright 2016 Contactually, Inc. http://contactually.com
