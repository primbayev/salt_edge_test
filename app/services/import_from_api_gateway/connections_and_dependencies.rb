module ImportFromApiGateway
  class ConnectionsAndDependencies
    def initialize(current_user)
      @current_user = current_user
    end

    def perform
      ActiveRecord::Base.transaction do
        all_salt_edge_connections = []
        all_salt_edge_accounts = []
        all_salt_edge_transactions = []

        salt_edge_connection_list = ApiGateway::Connection.new(@current_user).list
        connections_data = JSON.parse(salt_edge_connection_list.body).deep_symbolize_keys[:data]

        all_salt_edge_connections += connections_data

        connections_data.each do |salt_edge_conn|
          salt_edge_accounts = ::ApiGateway::Account.new(@current_user).show(salt_edge_conn[:id])
          accounts_data = JSON.parse(salt_edge_accounts.body).deep_symbolize_keys[:data]

          all_salt_edge_accounts += accounts_data

          accounts_data.each do |salt_edge_account|
            salt_edge_transactions = ::ApiGateway::Transaction
                                       .new(@current_user)
                                       .show(salt_edge_conn[:id], salt_edge_account[:id])
            transactions_data = JSON.parse(salt_edge_transactions.body)
                                    .deep_symbolize_keys[:data]

            salt_edge_pending_transactions = ::ApiGateway::Transaction
                                               .new(@current_user)
                                               .show_pending(salt_edge_conn[:id], salt_edge_account[:id])
            transactions_pending_data = JSON.parse(salt_edge_pending_transactions.body)
                                            .deep_symbolize_keys[:data]

            all_salt_edge_transactions += transactions_data
            all_salt_edge_transactions += transactions_pending_data
          end
        end

        import_data(::Connection, all_salt_edge_connections)
        import_data(::Account, all_salt_edge_accounts)
        import_data(::Transaction, all_salt_edge_transactions)
      end
    end

    private

    def import_data(model, data)
      column_names = model.column_names.map(&:to_sym)

      model.import(
        column_names,
        data,
        on_duplicate_key_update: {
          conflict_target: [:id],
          columns: column_names
        }
      )
    end
  end
end
