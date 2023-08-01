require 'rails_helper'

RSpec.describe Transaction, type: :model do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    @transaction = create(:transaction)
  end

  it "is valid with valid attributes" do
    expect(@transaction).to be_valid
  end

  it "is not valid without a account_id" do
    @transaction.account_id=nil
    expect(@transaction).to_not be_valid
  end

  it "is not valid without a created_at" do
    @transaction.created_at=nil
    expect(@transaction).to_not be_valid
  end

  it "is not valid without a updated_at" do
    @transaction.updated_at=nil
    expect(@transaction).to_not be_valid
  end
end
