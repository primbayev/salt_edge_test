require 'rails_helper'

RSpec.describe Customer, type: :model do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    @customer = create(:customer)
  end

  it "is valid with valid attributes" do
    expect(@customer).to be_valid
  end

  it "is not valid without a user_id" do
    @customer.user_id=nil
    expect(@customer).to_not be_valid
  end

  it "is not valid without a created_at" do
    @customer.created_at=nil
    expect(@customer).to_not be_valid
  end

  it "is not valid without a updated_at" do
    @customer.updated_at=nil
    expect(@customer).to_not be_valid
  end
end
