class TransactionsController < ApplicationController
  before_action :set_connection_and_account, only: :index

  def index
    @transactions = @account.transactions
  end

  private

  def set_connection_and_account
    connection = current_user
                   .customer
                   .connections.find(params[:connection_id])
    @account = connection.accounts.find(params[:account_id])
  end
end
