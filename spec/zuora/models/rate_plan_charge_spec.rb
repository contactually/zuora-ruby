require 'spec_helper'

describe Zuora::Models::RatePlanCharge do
  describe '#valid?' do
    context 'with invalid data' do
      subject { Zuora::Models::RatePlanCharge.new }

      it { expect { subject }.to raise_error }
    end

    context 'with valid data' do
      subject { build :rate_plan_charge }

      it { expect { subject }.to_not raise_error }
    end
  end
end
