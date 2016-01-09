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
      let(:sold_to_contact) do
        Zuora::Models::Contact.new(
          :first_name => 'First',
          :last_name => 'Last'
        )
      end

      let(:bill_to_contact) do
        Zuora::Models::Contact.new(
          :first_name => 'First',
          :last_name => 'Last'
        )
      end

      subject do
        Zuora::Models::Account.new(
          :name => 'Name',
          :currency => 'USD',
          :sold_to_contact => sold_to_contact,
          :bill_to_contact => bill_to_contact
        )
      end

      it 'should be valid with no data' do
        is_expected.to be_valid
      end

    end

    context 'without a bill_to_contact' do
      subject do
        Zuora::Models::Account.new(
          :name => 'Name',
          :currency => 'USD',
          :sold_to_contact => 3,
          :bill_to_contact => 3
        )
      end

      it 'should be invalid' do
        is_expected.to be_invalid
      end
    end

    context '' do
      subject do
        Zuora::Models::Account.new(
          :name => 'Name',
          :currency => 'USD',
          :sold_to_contact => Zuora::Models::Contact.new(
            :first_name => 'First', :last_name => 'Last'
          ),
          :bill_to_contact => Zuora::Models::Contact.new(
            :first_name => 'First', :last_name => 'Last'
          )
        )
      end
    end
  end
end