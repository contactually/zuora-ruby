require 'spec_helper'

describe Zuora::Models::Account do
  describe '.new' do
    context 'with_invalid data' do
      subject { build :account }

      it { expect { subject }.to raise_error }
    end

    context 'with valid data' do
      subject do
        build :account,
          bill_to_contact: build(:contact),
          sold_to_contact: build(:contact),
          credit_card: build(:credit_card)
      end

      it { expect { subject }.to_not raise_error }
    end
  end
end
