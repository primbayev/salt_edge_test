require 'rails_helper'

RSpec.describe User, type: :model do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    @user = create(:user)
  end

  it "is valid with valid attributes" do
    expect(@user).to be_valid
  end

  it "is not valid without a email" do
    @user.email=nil
    expect(@user).to_not be_valid
  end

  it "is not valid without a password" do
    @user.password=nil
    expect(@user).to_not be_valid
  end

  it "is not valid without a password_confirmation" do
    @user.password_confirmation=nil
    expect(@user).to_not be_valid
  end

  it "is not valid without a created_at" do
    @user.created_at=nil
    expect(@user).to_not be_valid
  end

  it "is not valid without a updated_at" do
    @user.updated_at=nil
    expect(@user).to_not be_valid
  end
end
