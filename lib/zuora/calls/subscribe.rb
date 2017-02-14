module Zuora
  module Calls
    class Subscribe < Hashie::Dash
      property :account, required: true
      property :payment_method
      property :bill_to_contact, required: true
      property :sold_to_contact
      property :subscribe_options
      property :subscription
      property :rate_plan
      property :rate_plan_charge

      SIMPLE_OBJECTS = [:account, :payment_method, :bill_to_contact].freeze

      # Generates a function that adds login fields to a buidler
      # @return [Callable] function of builder
      def xml_builder
        lambda do |builder|
          builder[:api].subscribe do
            builder[:api].subscribes do
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
          zuora_name = Zuora::Utils::Envelope.to_zuora_key obj_name
          builder[:api].send(zuora_name) do
            Zuora::Utils::Envelope.build_fields(builder, :obj, obj)
          end
        end
      end

      # Builds the complex, nested part of the subscribe request
      # @param [Nokogiri::XML::Builder] builder
      def build_complex_objects(builder)
        builder[:api].SubscribeOptions do
          Zuora::Utils::Envelope.build_fields(builder, :api, subscribe_options)
        end if subscribe_options

        builder[:api].SubscriptionData do
          build_object(builder, :Subscription, subscription)
          builder[:api].RatePlanData do
            build_object(builder, :RatePlan, rate_plan)
            builder[:api].RatePlanChargeData do
              build_object(builder, :RatePlanCharge, rate_plan_charge)
            end
          end
        end
      end

      # Helper for building one object
      # [Nokogiri::XML::Builder] builder
      # [Symbol] type
      # [Hash] data
      def build_object(builder, type, data)
        builder[:api].send(type) do
          build_fields builder, data
        end if data
      end

      # [Nokogiri::XML::Builder] builder
      # [Nokogiri::XML::Builder] builder
      # [Hash] data
      def build_fields(builder, data)
        Zuora::Utils::Envelope.build_fields(builder, :obj, data)
      end
    end
  end
end
