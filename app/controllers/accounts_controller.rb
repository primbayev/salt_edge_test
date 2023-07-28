class AccountsController < ApplicationController
  def index
    @accounts = current_user.customer.connections.find(params[:connection_id]).accounts
  end
end
