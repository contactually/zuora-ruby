require 'spec_helper'
require 'ostruct'

describe Zuora::Serializers::Attribute do
  let(:obj) do
    OpenStruct.new(
      :a_b => 1,
      :b_c => 2,
      :c_d => OpenStruct.new(
        :attributes => [:e_f, :f_g],
        :e_f => 3,
        :f_g => 4
      ),
      :attributes => [:a_b, :b_c, :c_d]
    )
  end

  let(:expected_result) do
    {
      'aB' => 1,
      'bC' => 2,
      'cD' => {
        'eF' => 3,
        'fG' => 4
      }
    }
  end

  subject { Zuora::Serializers::Attribute.serialize obj }

  it { is_expected.to eq expected_result }
end