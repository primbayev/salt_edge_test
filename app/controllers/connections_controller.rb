class ConnectionsController < ApplicationController
  def index
    @connections = current_user.customer.connections
  end

  def create
    ImportConnectionsAccountsTransactionsJob.perform_async(current_user.id)

    redirect_to connections_path
  end

  def refresh
    RefreshConnectionJob.perform_async(current_user.id, params[:connection_id])

    redirect_to connections_path
  end
end
