require 'spec_helper'

describe Zuora::Models::Account do
  let(:account_model_1) do
    build :account_model,
      credit_card: build(:credit_card_model),
      bill_to_contact: build(:contact_hash),
      sold_to_contact: build(:contact_model),
      subscription: build(:subscription_hash)
  end

  let(:account_model_2) do
    build :account_model,
      credit_card: build(:credit_card_hash),
      bill_to_contact: build(:contact_model),
      sold_to_contact: build(:contact_hash),
      subscription: build(:subscription_model)
  end

  it { expect(account_model_1.errors).to be_empty }
  it { expect(account_model_2.errors).to be_empty }

  it { expect(account_model_1).to be_valid }
  it { expect(account_model_2).to be_valid }
end
