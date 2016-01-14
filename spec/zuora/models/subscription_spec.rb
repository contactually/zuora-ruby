require 'spec_helper'

describe Zuora::Models::Account do
  describe '.new?' do
    context 'with invalid data' do
      subject { Zuora::Models::Subscription.new }

      it { expect { subject }.to raise_error }
    end

    context 'with valid data' do
      let(:rate_plan) { build :rate_plan }

      subject do
        build :subscription,
              subscribe_to_rate_plans: [rate_plan]
      end

      it { expect { subject }.to_not raise_error }
    end
  end
end
