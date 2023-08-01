require 'rails_helper'

RSpec.describe Account, type: :model do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    @account = create(:account)
  end

  it "is valid with valid attributes" do
    expect(@account).to be_valid
  end

  it "is not valid without a connection_id" do
    @account.connection_id=nil
    expect(@account).to_not be_valid
  end

  it "is not valid without a created_at" do
    @account.created_at=nil
    expect(@account).to_not be_valid
  end

  it "is not valid without a updated_at" do
    @account.updated_at=nil
    expect(@account).to_not be_valid
  end
end
