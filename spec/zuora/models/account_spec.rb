require 'spec_helper'

describe Zuora::Models::Account do
  describe '#valid?' do
    context 'with invalid data' do
      subject { Zuora::Models::Account.new }

      it 'should be invalid with no data' do
        expect(subject.valid?).to eq false
      end
    end

    context 'with valid data' do
      subject do
        build :account,
              bill_to_contact: build(:contact),
              sold_to_contact: build(:contact),
              credit_card: build(:credit_card)
      end

      it { is_expected.to be_valid }
    end
  end
end
