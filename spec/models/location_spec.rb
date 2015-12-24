# encoding: utf-8
require 'spec_helper'

describe Isone::Location do
  let(:data) do
    {
      '@LocId' => 1,
      '@LocType' => 'NETWORK NODE',
      '$' => 'LD.BEAN_HIL13.8'
    }
  end

  subject { Isone::Location.new(data) }

  its(:id) { should eq data['@LocId'] }
  its(:type) { should eq data['@LocType'] }
  its(:name) { should eq data['$'] }
end
