require 'spec_helper'

class SchemaModelSpec
  include SchemaModel
  extend ValidationPredicates

  schema :schema_model_spec,
    id: {
      type: Numeric,
      required?: true,
      valid?: -> (v) { v > 0 }
    },
    label_field: {
      type: String,
      valid?: max_length(5)
    }
end

describe SchemaModelSpec do
  context 'with invalid data' do
    let(:subject) do
      SchemaModelSpec.new
    end

    let(:errors) do
      {
        id: {
          required?: 'is required but is not set'
        }
      }
    end

    it { is_expected.to_not be_valid }
    it { expect(subject.errors).to eq errors }
  end

  context 'with valid data' do
    let(:subject) do
      SchemaModelSpec.new(id: 1, label_field: '12345')
    end

    let(:json) do
      {
        'id' => 1,
        'labelField' => '12345'
      }
    end

    it { is_expected.to be_valid }
    it { expect(subject.errors).to be_empty }
    it { expect(subject.to_json).to eq json }
  end

end
