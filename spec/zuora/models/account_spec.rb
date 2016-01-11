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
        Zuora::Models::Account.new(
          :name => 'Abc',
          :auto_pay => true,
          :currency => 'USD',
          :bill_cycle_day => '0',
          :payment_term => 'Net 30',
          :bill_to_contact => Zuora::Models::Contact.new(
            :first_name => 'Abc',
            :last_name => 'Def',
            :address_1 => '123 Main St',
            :city => 'Palm Springs',
            :state => 'FL',
            :zip_code => '90210',
            :country => 'US'
          ),
          :sold_to_contact => Zuora::Models::Contact.new(
            :first_name => 'Abc',
            :last_name => 'Def',
            :country => 'US'
          ),
          :credit_card => Zuora::Models::PaymentMethod.new(
            :card_type => 'Visa',
            :card_number => '4111111111111111',
            :expiration_month => '03',
            :expiration_year => '2017',
            :security_code => '122',
          )
        )
      end

      it { is_expected.to be_valid }

    end
  end
end