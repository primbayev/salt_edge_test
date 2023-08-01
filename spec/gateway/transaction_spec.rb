require 'rails_helper'

RSpec.describe ApiGateway::Transaction do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    @connection = Connection.create(id: CONNECTION_ID, customer_id: CUSTOMER_ID)
    @account = Account.create(id: ACCOUNT_ID, connection_id: @connection.id)
  end

  describe 'check ApiGateway::Transaction' do
    let(:show_transaction) { described_class.new(@user).show(@connection.id, @account.id) }
    let(:expected_data) do
      {
        data: [
          {
            id: TRANSACTION_ID,
            account_id: @account.id,
            made_on: '2023-05-11',
            category: 'shopping',
            description: 'transaction description',
            status: 'posted',
            duplicated: false,
            amount: 100.00,
            currency_code: 'EUR',
            created_at: '2023-05-11',
            updated_at: '2023-05-11'
          }
        ]
      }
    end
    it 'get transaction data' do
      expect(show_transaction.body).to eq(JSON.generate(expected_data))
    end

    let(:show_transaction_pending) { described_class.new(@user).show_pending(@connection.id, @account.id) }
    let(:expected_data_pending) do
      {
        data: [
          {
            id: TRANSACTION_PENDING_ID,
            account_id: @account.id,
            made_on: '2023-05-11',
            category: 'shopping',
            description: 'transaction description',
            status: 'pending',
            duplicated: false,
            amount: 100.00,
            currency_code: 'EUR',
            created_at: '2023-05-11',
            updated_at: '2023-05-11'
          }
        ]
      }
    end
    it 'get transaction pending data' do
      expect(show_transaction_pending.body).to eq(JSON.generate(expected_data_pending))
    end
  end
end
