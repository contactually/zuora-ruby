require 'spec_helper'

describe Zuora::Models::Account do
  describe '.new' do
    context 'with valid data' do
      subject do
        build :account,
              bill_to_contact: build(:contact),
              sold_to_contact: build(:contact),
              credit_card: build(:credit_card)
      end

      it { is_expected.to_not raise_error }
    end
  end
end
