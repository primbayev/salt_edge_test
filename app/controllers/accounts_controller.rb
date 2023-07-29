class AccountsController < ApplicationController
  before_action :set_connection, only: :index

  def index
    @accounts = @connection.accounts
  end

  private

  def set_connection
    @connection = current_user.customer.connections.find(params[:connection_id])
  end
end
