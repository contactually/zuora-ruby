require 'spec_helper'

describe Zuora::Models::RatePlanCharge do
  describe '#valid?' do
    context 'with invalid data' do
      subject { Zuora::Models::RatePlanCharge.new }

      it { is_expected.to_not be_valid }
    end

    context 'with valid data' do
      subject { build :rate_plan_charge }

      it { is_expected.to be_valid }
    end
  end
end
