[![Circle CI](https://circleci.com/gh/contactually/zuora-ruby.svg?style=shield&circle-token=808be5d625e91e331bedb37a2fe94412bb3bc15e)](https://circleci.com/gh/contactually/zuora-ruby)
[![Code Climate](https://codeclimate.com/repos/569444dfa3d810003a00313f/badges/416bae00acf65d690efe/gpa.svg)](https://codeclimate.com/repos/569444dfa3d810003a00313f/feed)
[![Test Coverage](https://codeclimate.com/repos/569444dfa3d810003a00313f/badges/416bae00acf65d690efe/coverage.svg)](https://codeclimate.com/repos/569444dfa3d810003a00313f/coverage)

# Zuora REST API: Ruby Client

# Building Blocks

## Models
- Provide ***recursive** data driven validations, accessors, tracking and coercion. 
- Provides Ruby builder patterns for request construction
- See examples below

# HTTP Client 
- JSON encoding, authentication, request and response 

# Examples

## Simple Example
```ruby
class ChildSchema
  include Schema
  
  schema :item,
    id: {
      type: Numeric,
    },

    label: {
      type: String,
    },
end

class ParentSchema
  include Schema
  schema :items,
   id: {
     type: Numeric,
   },
   items: {
     type: String,
     schema: [ChildSchema]
   }
 end
  
 items.valid? 
 => true
```


## Subscription Example
Zuora's subscription endpoint is a nested 4-level object.
 subscriptions => 

```ruby
 subscription = Zuora::Models::Root.new(
  account_key: -3, 
  subscribe_to_rate_plans: 
   [{ :product_rate_plan_id => 3,
      :charge_overrides => [] }] )

> subscription.errors

=>  {:account_key=>{:type=>"should be of type String but is of type Fixnum"},
     :subscribe_to_rate_plans=>[]}
  
> subscription.valid? 

true

# Now it can be serialized and sent via HTTP

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

* **[0.3.0 2016-]** Stronger models and improved Resource API
    - The goal of this iteration was to find a high-leverage way to get extremely close to the Zuora REST API specification.
      The approach taken is to declare in full detail Zuora REST specs using data, and then use Ruby's metaprogramming 
      facilities to create a Ruby object interface with convenience features such as dirty attribute tracking, builder pattern, etc.
    - Implements `SchemaModel`, a metaclass providing a declarative data Ruby DSL
        - docstrings from zuora so API spec is co-located 
        
        - validations
        - type checks
        - required? fields

        or
       
        - schema: one or many. Provides a means for recursion

    - Implements Zuora models using `SchemaModel` for: Account, CardHolderInfo, Charge, Contact, CreditCard, Plan, Subscription, Tier
    - Previously, only one error at a time was thrown. Now, all model validations are inspectable at once 
    - Updates factories with both Hash and Model constructors
    - Removes Resources construct
    - Adds SOAP Client
    - Removes validations
   
    
# Commit rights
Anyone who has a patch accepted may request commit rights. Please do so inside the pull request post-merge.

# Contributors
* [John Gerhardt](https://github.com/jwg2s)
* [Shaun Robinson](https://github.com/env)

# License
MIT License. Copyright 2016 Contactually, Inc. http://contactually.com
