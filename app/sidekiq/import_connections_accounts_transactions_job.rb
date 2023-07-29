class ImportConnectionsAccountsTransactionsJob
  include Sidekiq::Job

  def perform(current_user_id)
    current_user = ::User.find(current_user_id)
    ImportFromApiGateway::ConnectionsAndDependencies.new(current_user).process
  end
end
