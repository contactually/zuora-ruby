# encoding: utf-8
require 'spec_helper'

describe Isone::FiveMinLmp do
  let(:date) { DateTime.parse('2015-12-23') }
  let(:location) { 4475 }

  subject do
    VCR.use_cassette('cassettes/lmp', match_requests_on: [:path]) do
      Isone::Lmp.new(date, location)
    end
  end

  it 'sets the lmps attr' do
    expect(subject.lmps).to be_a_kind_of(Array)
    expect(subject.lmps.map(&:class).uniq.first).to eq Isone::FiveMinLmp
  end
end
