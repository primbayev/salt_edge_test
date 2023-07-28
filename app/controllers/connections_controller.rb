class ConnectionsController < ApplicationController
  def index
    @connections = current_user.customer.connections
  end

  def create
    ActiveRecord::Base.transaction do
      connection = ApiGateway::Connection.new(current_user).show(params[:connection_id])
      customer_salt_edge_id = JSON.parse(connection.body).deep_symbolize_keys[:data][:customer_id]
      salt_edge_list = ApiGateway::Connection.new(current_user).list(customer_salt_edge_id)

      JSON.parse(salt_edge_list.body).deep_symbolize_keys[:data].each do |salt_edge_conn|
        conn = ::Connection.find_or_create_by(salt_edge_id: salt_edge_conn[:id])

        conn.update(
          provider_id: salt_edge_conn[:provider_id],
          provider_code: salt_edge_conn[:provider_code],
          provider_name: salt_edge_conn[:provider_name],
          status: salt_edge_conn[:status],
          customer_id: ::Customer.find_by(salt_edge_id: salt_edge_conn[:customer_id]).id
        )

        salt_edge_accounts = ::ApiGateway::Account.new(current_user).show(conn.salt_edge_id)
        JSON.parse(salt_edge_accounts.body).deep_symbolize_keys[:data].each do |salt_edge_account|
          account = ::Account.find_or_create_by(salt_edge_id: salt_edge_account[:id])

          account.update(
            connection_id: conn.id,
            name: salt_edge_account[:name],
            nature: salt_edge_account[:nature],
            balance: salt_edge_account[:balance],
            currency_code: salt_edge_account[:currency_code]
          )

          salt_edge_transactions = ::ApiGateway::Transaction
                                     .new(current_user)
                                     .show(conn.salt_edge_id, account.salt_edge_id)

          JSON.parse(salt_edge_transactions.body).deep_symbolize_keys[:data].each do |salt_edge_transaction|
            transaction = ::Transaction.find_or_create_by(salt_edge_id: salt_edge_transaction[:id])

            transaction.update(
              account_id: account.id,
              made_on: salt_edge_transaction[:made_on].to_date,
              category: salt_edge_transaction[:category],
              description: salt_edge_transaction[:description],
              status: salt_edge_transaction[:status],
              duplicated: salt_edge_transaction[:duplicated],
              amount: salt_edge_transaction[:amount],
              currency_code: salt_edge_transaction[:currency_code]
            )
          end

          salt_edge_pending_transactions = ::ApiGateway::Transaction
                                             .new(current_user)
                                             .show_pending(conn.salt_edge_id, account.salt_edge_id)

          JSON.parse(salt_edge_pending_transactions.body).deep_symbolize_keys[:data].each do |salt_edge_transaction|
            pending_transaction = ::Transaction.find_or_create_by(salt_edge_id: salt_edge_transaction[:id])

            pending_transaction.update(
              account_id: account.id,
              made_on: salt_edge_transaction[:made_on].to_date,
              category: salt_edge_transaction[:category],
              description: salt_edge_transaction[:description],
              status: salt_edge_transaction[:status],
              duplicated: salt_edge_transaction[:duplicated],
              amount: salt_edge_transaction[:amount],
              currency_code: salt_edge_transaction[:currency_code]
            )
          end
        end
      end
    end

    redirect_to connections_path
  end
end
