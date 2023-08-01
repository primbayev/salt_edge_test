require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before do
    @transaction = create(:transaction)
    @account = @transaction.account
    @connection = @account.connection
    @user = @connection.customer.user
  end

  describe "GET /index" do
    it "renders the index template when the route is /connections/:connection_id/accounts/:account_id/transactions" do
      login_as(@user, scope: :user)
      get connection_account_transactions_path(@connection, @account)

      expect(response).to be_successful
    end
  end
end
