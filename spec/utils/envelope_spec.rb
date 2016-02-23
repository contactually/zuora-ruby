require 'spec_helper'
require 'active_support/core_ext/hash/conversions'

describe Zuora::Utils::Envelope do
  let(:builder) { Nokogiri::XML::Builder.new }

  describe 'nested recursive zobjects' do
    let(:rate_plan_data) do
      [
        {
          id: '123',
          charge_model: 'DiscountPercentage',
          product_rate_plan_charge_tier_data:
            Zuora::Soap::ZObject.new(
              :product_rate_plan_charge_tier,
              discount_percentage: 22.22,
              id: '123'
            )
        }
      ]
    end

    let(:generated_xml) do
      builder.update(Zuora::NAMESPACES) do |builder|
        Zuora::Utils::Envelope.build_objects(
          builder,
          :ProductRatePlanCharge,
          rate_plan_data
        )
      end
      builder.to_xml
    end

    let(:parsed_xml) { Nokogiri::XML(generated_xml) }

    xpath_selectors = %w(
      //obj:ProductRatePlanChargeTierData/api:ProductRatePlanChargeTier
      //api:ProductRatePlanChargeTier/obj:DiscountPercentage
      //api:ProductRatePlanChargeTier/obj:Id
    )

    xpath_selectors.each do |selector|
      it "selector is not empty: \n #{selector}" do
        expect(parsed_xml.xpath(selector)).to_not be_empty
      end
    end
  end
end
