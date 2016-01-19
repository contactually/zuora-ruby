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
  end

  module InstanceMethods
    attr_accessor :model

    PARAM_REGEXP = /:[a-z0-9_]+/

    def initialize(model, client)
      fail 'Model must be valid' unless model.valid?
      @model = model
    end

    def exec!(env = :sandbox)
      puts "Executing HTTP #{request_method} to #{url}"
      resp = @client.send(request_method, url, serialized_model)
    end

    def request_method
      definition[:request][:method]
    end

    def raw_url(env = :sandbox)
      definition[:request][:urls][env]
    end

    def serialized_model
      @model.to_json
    end

    # Renders URL parameters
    def url(env = :sandbox)
      _url = raw_url(env)
      matches = PARAM_REGEXP.match(_url)
      _url = matches
        .to_a
        .reduce(_url) { |memo, attr| render_url_param(memo, attr) }
    end

    private

    def render_url_param(_url, attr)
      attr_sym = attr[1..-1].to_sym
      _url.gsub attr, @model.send(attr_sym).to_s
    end

  end

  # Dynamically configures a ResourceModel class
  # @param [String] name - The classes name
  # @param [Hash] opts [:human_name
  #                     :doc_url
  #                     :description
  #                     :cors
  #                     :request  [:method, :content_type, :urls, :schema]
  #                     :response]
  module ClassMethods
    def resource(_name, opts = {})
      # [:human_name, :doc_url, :description, :cors, :request, :response]
      # [:method, :content_type, :urls, :schema]

      define_method(:definition) { opts }
    end
  end
end
