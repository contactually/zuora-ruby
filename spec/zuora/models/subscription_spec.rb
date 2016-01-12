require 'spec_helper'

describe Zuora::Models::Account do
  describe '#valid?' do
    context 'with invalid data' do
      subject { Zuora::Models::Subscription.new }

      it 'should be invalid with no data' do
        expect(subject.valid?).to eq false
      end
    end

    context 'with valid data' do
      let(:rate_plan) { build :rate_plan }

      subject do
        build :subscription,
              subscribe_to_rate_plans: [rate_plan]
      end

      it { is_expected.to be_valid }
    end
  end
end
