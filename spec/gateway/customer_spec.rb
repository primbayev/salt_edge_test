require 'rails_helper'

RSpec.describe ApiGateway::Customer do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    @user = create(:user)
  end

  describe 'check ApiGateway::Customer' do
    let(:create_customer) { described_class.new(@user).create }
    it 'changes Customer count' do
      expect { create_customer }.to change { Customer.count }.by(1)
    end
  end
end
