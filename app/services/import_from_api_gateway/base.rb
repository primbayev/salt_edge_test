module ImportFromApiGateway
  class Base

    private

    def accounts_and_transactions_from_salt_edge(connection_id)
      all_salt_edge_accounts = []
      all_salt_edge_transactions = []

      salt_edge_accounts = ::ApiGateway::Account.new(@current_user).show(connection_id)
      accounts_data = JSON.parse(salt_edge_accounts.body).deep_symbolize_keys[:data]

      all_salt_edge_accounts += accounts_data

      accounts_data.each do |salt_edge_account|
        salt_edge_transactions = ::ApiGateway::Transaction
                                   .new(@current_user)
                                   .show(connection_id, salt_edge_account[:id])
        transactions_data = JSON.parse(salt_edge_transactions.body)
                                .deep_symbolize_keys[:data]

        salt_edge_pending_transactions = ::ApiGateway::Transaction
                                           .new(@current_user)
                                           .show_pending(connection_id, salt_edge_account[:id])
        transactions_pending_data = JSON.parse(salt_edge_pending_transactions.body)
                                        .deep_symbolize_keys[:data]

        all_salt_edge_transactions += transactions_data
        all_salt_edge_transactions += transactions_pending_data
      end

      {
        accounts: all_salt_edge_accounts,
        transactions: all_salt_edge_transactions
      }
    end

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
