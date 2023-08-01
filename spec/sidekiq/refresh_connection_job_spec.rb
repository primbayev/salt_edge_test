require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe RefreshConnectionJob, type: :worker do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before do
    password = Faker::Internet.password
    @user = User.create(
      id: USER_ID,
      email: Faker::Internet.email,
      password: password,
      password_confirmation: password
    )
    @customer = Customer.create(id: CUSTOMER_ID, identifier: @user.email, user_id: @user.id)
    @connection = Connection.create(id: CONNECTION_ID, customer_id: @customer.id)
  end

  describe 'testing RefreshConnectionJob' do
    it 'job in correct queue' do
      described_class.perform_async
      assert_equal "default", described_class.queue
    end

    it 'goes into the jobs array for testing environment' do
      expect do
        described_class.perform_async
      end.to change(described_class.jobs, :size).by(1)
      described_class.new.perform(@user.id, @connection.id)
    end

    let(:create_account_and_dependencies) { described_class.new.perform(@user.id, @connection.id) }
    it 'changes Account count' do
      expect { create_account_and_dependencies }.to change { Account.count }.by(1)
    end

    it 'changes Transaction count' do
      expect { create_account_and_dependencies }.to change { Transaction.count }.by(2)
    end
  end
end
