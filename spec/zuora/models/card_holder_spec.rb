require 'spec_helper'

describe Zuora::Models::CardHolder do
  describe '#valid?' do
    context 'with invalid data' do
      subject { Zuora::Models::CardHolder.new }

      it { is_expected.to_not be_valid }

    end

    context 'with valid data' do
      subject { build :card_holder }

      it { is_expected.to be_valid }
    end
  end
end