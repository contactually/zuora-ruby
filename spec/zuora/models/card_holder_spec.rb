require 'spec_helper'

describe Zuora::Models::CardHolder do
  describe '.new?' do
    context 'with invalid data' do
      subject { Zuora::Models::CardHolder.new }

      it { expect { subject }.to raise_error }
    end

    context 'with valid data' do
      subject { build :card_holder }

      it { expect { subject }.to_not raise_error }
    end
  end
end


