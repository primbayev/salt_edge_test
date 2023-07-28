class TransactionsController < ApplicationController
  def index
    @transactions = current_user
                      .customer
                      .connections.find(params[:connection_id])
                      .accounts.find(params[:account_id])
                      .transactions
  end
end
