require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe "Connections", type: :request do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before do
    @connection = create(:connection)
    @user = @connection.customer.user
  end

  describe "GET /index" do
    it "renders the index template when the route is /connections" do
      login_as(@user, scope: :user)
      get connections_path

      expect(response).to be_successful
    end
  end

  describe "GET /connections/create" do
    it "imports transactions and accounts" do
      login_as(@user, scope: :user)
      get connections_create_path

      expect(response).to redirect_to '/connections'
    end
  end

  describe "GET /connections/:connection_id/refresh" do
    it "refreshes connection" do
      login_as(@user, scope: :user)
      get connections_refresh_path(@connection)

      expect(response).to redirect_to '/connections'
    end
  end
end
