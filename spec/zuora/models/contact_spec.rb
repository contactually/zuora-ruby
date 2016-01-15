require 'spec_helper'

describe Zuora::Models::Contact do
  describe '.new' do
    context 'with invalid data' do
      subject { Zuora::Models::Contact.new }

      it { expect { subject }.to raise_error }
    end

    context 'with valid data' do
      subject { build :contact }

      it { expect { subject }.to_not raise_error }
    end
  end
end
