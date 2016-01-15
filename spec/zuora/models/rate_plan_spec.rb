require 'spec_helper'

describe Zuora::Models::RatePlanChargeTier do
  describe '.new?' do
    context 'with invalid data' do
      subject { Zuora::Models::RatePlanChargeTier.new }

      it { expect { subject }.to raise_error }
    end

    context 'with valid data' do
      subject { build :rate_plan_charge_tier }

      it { expect { subject }.to_not raise_error }
    end
  end
end
