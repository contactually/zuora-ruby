require 'spec_helper'

describe Zuora::Models::Subscription do

  let(:subscription_model) do
    build :subscription,
      subscribe_to_rate_plans: [build(:plan_hash)]
  end

  it { expect(subscription_model.errors).to be_empty }

  it { expect(subscription_model).to be_valid }
end
