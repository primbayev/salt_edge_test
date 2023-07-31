require 'rails_helper'

RSpec.describe Connection, type: :model do
  before(:all) do
    @connection = create(:connection)
  end

  it "is valid with valid attributes" do
    expect(@connection).to be_valid
  end

  it "is not valid without a customer_id" do
    @connection.customer_id=nil
    expect(@connection).to_not be_valid
  end

  it "is not valid without a created_at" do
    @connection.created_at=nil
    expect(@connection).to_not be_valid
  end

  it "is not valid without a updated_at" do
    @connection.updated_at=nil
    expect(@connection).to_not be_valid
  end
end
