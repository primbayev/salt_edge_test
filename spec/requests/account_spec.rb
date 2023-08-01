require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before do
    @account = create(:account)
    @connection = @account.connection
    @user = @connection.customer.user
  end

  describe "GET /index" do
    it "renders the index template when the route is /connections/:connection_id/accounts" do
      login_as(@user, scope: :user)
      get connection_accounts_path(@connection)

      expect(response).to be_successful
    end
  end
end
