# encoding: utf-8
require 'spec_helper'

describe Isone::FiveMinLmp do
  let(:data) do
    {
      'BeginDate' => '2015-12-23T00:00:05.000-05:00',
      'Location' => {
        '@LocType' => 'NETWORK NODE',
        '@LocId' => '4475',
        '$' => 'LD.BEAN_HIL13.8'
      },
      'LmpTotal' => 16.2,
      'EnergyComponent' => 16.34,
      'CongestionComponent' => 0,
      'LossComponent' => -0.14
    }
  end

  subject { Isone::FiveMinLmp.new(data) }

  its(:begin_date) { should eq data['BeginDate'] }
  its(:location) { should be_a_kind_of Isone::Location }
  its(:lmp_total) { should eq data['LmpTotal'] }
  its(:energy_component) { should eq data['EnergyComponent'] }
  its(:congestion_component) { should eq data['CongestionComponent'] }
  its(:loss_component) { should eq data['LossComponent'] }
end
