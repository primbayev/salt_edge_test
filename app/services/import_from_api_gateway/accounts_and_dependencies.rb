module ImportFromApiGateway
  class AccountsAndDependencies < Base
    def initialize(current_user, connection_id)
      @current_user = current_user
      @connection_id = connection_id
    end

    def process
      ActiveRecord::Base.transaction do
        accounts_and_transactions = accounts_and_transactions_from_salt_edge(@connection_id)

        import_data(::Account, accounts_and_transactions[:accounts])
        import_data(::Transaction, accounts_and_transactions[:transactions])
      end
    end
  end
end
