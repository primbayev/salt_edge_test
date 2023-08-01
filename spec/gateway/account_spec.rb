require 'rails_helper'

RSpec.describe ApiGateway::Account do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    @connection = Connection.create(id: CONNECTION_ID, customer_id: CUSTOMER_ID)
  end

  describe 'check ApiGateway::Account' do
    let(:show_connection) { described_class.new(@user).show(@connection.id) }
    let(:expected_data) do
      {
        data: [
          {
            id: ACCOUNT_ID,
            connection_id: @connection.id,
            currency_code: 'EUR',
            nature: 'credit',
            name: 'fake name',
            balance: 100.00,
            created_at: '2023-05-11',
            updated_at: '2023-05-11'
          }
        ]
      }
    end
    it 'get account data' do
      expect(show_connection.body).to eq(JSON.generate(expected_data))
    end
  end
end
