module ImportFromApiGateway
  class ConnectionsAndDependencies < Base
    def initialize(current_user)
      @current_user = current_user
    end

    def process
      ActiveRecord::Base.transaction do
        all_salt_edge_connections = []
        all_salt_edge_accounts = []
        all_salt_edge_transactions = []

        salt_edge_connection_list = ApiGateway::Connection.new(@current_user).list
        connections_data = JSON.parse(salt_edge_connection_list.body).deep_symbolize_keys[:data]

        all_salt_edge_connections += connections_data

        connections_data.each do |salt_edge_conn|
          accounts_and_transactions = accounts_and_transactions_from_salt_edge(salt_edge_conn[:id])

          all_salt_edge_accounts += accounts_and_transactions[:accounts]
          all_salt_edge_transactions += accounts_and_transactions[:transactions]
        end

        import_data(::Connection, all_salt_edge_connections)
        import_data(::Account, all_salt_edge_accounts)
        import_data(::Transaction, all_salt_edge_transactions)
      end
    end
  end
end
