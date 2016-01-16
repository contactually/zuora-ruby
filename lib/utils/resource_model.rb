require_relative 'validation_predicates'
require_relative 'composite_types'
require 'byebug'

# Create a resource
# resource = Zuora::Subscription::Update.new( account_id: 1,
#                                             auto_renew: true )

# resource.valid? => false
# resource.errors => [ { subscription_key: ['is required']  } ]

# Accessors
# resource.subscription_key = '123'

# Fire request
# resource.valid? => true
# resp = resource.request!

module ResourceModel
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
    base.extend ValidationPredicates
  end

  module InstanceMethods
    attr_reader :errors

    def initialize
      @errors = []
    end

    def valid?
      @errors = [:a]
      nil
    end

    def exec!(env = :sandbox)
      url_template = self.request[:uris][env]
      url = url_template.gsub '{subscription_key}', 'get-value-from-instance'
      puts "Executing HTTP #{self.http_method} to #{url}"
    end
  end

  module ClassMethods
    def resource(name, opts = {})
      define_method(:name) { name }
      opts.each { |k, value| define_method("#{k}") { value } }
    end
  end
end