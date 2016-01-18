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
    private

    # def exec!(env = :sandbox)
    #   url_template = request[:uris][env]
    #   url = url_template.gsub '{subscription_key}', 'get-value-from-instance'
    #   puts "Executing HTTP #{http_method} to #{url}"
    # end
  end

  module ClassMethods
    def resource(name, opts = {})
      # TODO
    end
  end
end
