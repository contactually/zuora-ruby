require 'spec_helper'

describe Zuora::Models::CardHolder do
  describe '#valid?' do
    context 'with invalid data' do
      subject { Zuora::Models::CardHolder.new }

      it { is_expected.to_not be_valid }

    end

    context 'with valid data' do
      subject do
        Zuora::Models::CardHolder.new(
          :card_holder_name => 'First Last',
          :address_line_1 => '123 Main St',
          :city => 'Dayton',
          :state => 'OH',
          :country => 'USA',
          :phone => '301-555-1212',
          :email => 'abc@abc.com',
          :zip_code => '12345'
        )
      end

      it { is_expected.to be_valid }
    end
  end
end