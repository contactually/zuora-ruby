require 'spec_helper'

describe Zuora::Contact do
  describe '#valid?' do
    context 'with invalid data' do
      subject { Zuora::Contact.new }

      it { is_expected.to_not be_valid }

    end

    context 'with valid data' do
      subject do
        Zuora::Contact.new :first_name => 'First',
                           :last_name => 'Last'
      end

      it { is_expected.to be_valid }
    end
  end
end