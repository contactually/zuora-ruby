module Zuora
  module Soap
    module Calls
      class Subscribe < Hashie::Dash
        property :account, required: true
        property :payment_method
        property :bill_to_contact, required: true
        property :sold_to_contact
        property :subscribe_options
        property :subscription
        property :rate_plan

        SIMPLE_OBJECTS = [:account, :payment_method, :bill_to_contact].freeze

        # Generates a function that adds login fields to a buidler
        # @return [Callable] function of builder
        def xml_builder
          lambda do |builder|
            builder[:ns1].subscribe do
              builder[:ns1].subscribes do
                build_simple_objects builder
                build_complex_objects builder
              end
            end
          end
        end

        private

        # Builds the non-complex / non-nested part of the subscribe request
        # @param [Nokogiri::XML::Builder] builder
        def build_simple_objects(builder)
          SIMPLE_OBJECTS.each do |obj_name|
            obj = send obj_name
            next unless obj
            zuora_name = Zuora::Soap::Utils::Envelope.to_zuora_key obj_name
            builder[:ns1].send(zuora_name) do
              Zuora::Soap::Utils::Envelope.build_fields(builder, :ns2, obj)
            end
          end
        end

        # Builds the complex, nested part of the subscribe request
        # @param [Nokogiri::XML::Builder] builder
        def build_complex_objects(builder)
          build_object(builder, :SubscribeOptions, subscribe_options)
          builder[:ns1].SubscriptionData do
            build_object(builder, :SubscribeOptions, subscribe_options)
            build_object(builder, :Subscription, subscription)
            builder[:ns1].RatePlanData do
              build_object(builder, :RatePlan, rate_plan)
            end
          end
        end

        # Helper for building one object
        # [Nokogiri::XML::Builder] builder
        # [Symbol] type
        # [Hash] data
        def build_object(builder, type, data)
          builder[:ns1].send(type) do
            build_fields builder, data
          end if data
        end

        # [Nokogiri::XML::Builder] builder
        # [Nokogiri::XML::Builder] builder
        # [Hash] data
        def build_fields(builder, data)
          Zuora::Soap::Utils::Envelope.build_fields(builder, :ns2, data)
        end
      end
    end
  end
end
