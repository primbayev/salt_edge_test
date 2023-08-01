require 'rails_helper'

RSpec.describe ApiGateway::Connection do
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:all) do
    password = Faker::Internet.password
    @user = User.create(
      id: USER_ID,
      email: Faker::Internet.email,
      password: password,
      password_confirmation: password
    )
    @customer = Customer.create(id: CUSTOMER_ID, user_id: @user.id)
    @connection = Connection.create(id: CONNECTION_ID, customer_id: @customer.id)
  end

  describe 'check ApiGateway::Connection' do
    let(:connection_list) { described_class.new(@user).list }
    let(:connection_list_response) do
      {
        data: [
          {
            id: CONNECTION_ID,
            provider_id: 'provider id',
            provider_code: 'fake_bank',
            provider_name: 'Fake bank',
            status: 'status',
            customer_id: @customer.id,
            created_at: '2023-05-11',
            updated_at: '2023-05-11'
          }
        ]
      }
    end
    it 'get connection list' do
      expect(connection_list.body).to eq(JSON.generate(connection_list_response))
    end

    let(:create_connect_session) { described_class.new(@user).create_connect_session(@customer, 'url') }
    let(:create_connect_session_response) { { data: { connect_url: 'http://localhost:3000/' } } }
    it 'create connect session' do
      expect(create_connect_session.body).to eq(JSON.generate(create_connect_session_response))
    end

    let(:create_reconnect_session) { described_class.new(@user).create_reconnect_session(@connection, 'url') }
    let(:create_reconnect_session_response) { { data: { connect_url: 'http://localhost:3000/' } } }
    it 'create reconnect session' do
      expect(create_reconnect_session.body).to eq(JSON.generate(create_reconnect_session_response))
    end

    let(:refresh_connection) { described_class.new(@user).refresh_connection(@connection.id) }
    let(:refresh_connection_response) { { data: {} } }
    it 'create reconnect session' do
      expect(refresh_connection.body).to eq(JSON.generate(refresh_connection_response))
    end
  end
end
