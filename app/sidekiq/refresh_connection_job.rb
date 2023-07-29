class RefreshConnectionJob
  include Sidekiq::Job

  def perform(current_user_id, connection_id)
    current_user = ::User.find(current_user_id)
    ApiGateway::Connection.new(current_user).refresh_connection(connection_id)
    ImportFromApiGateway::ConnectionsAndDependencies.new(current_user).perform
  end
end
