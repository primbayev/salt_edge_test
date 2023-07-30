class RefreshConnectionJob
  include Sidekiq::Job

  def perform(current_user_id, connection_id)
    @current_user = ::User.find(current_user_id)
    @connection_id = connection_id

    ApiGateway::Connection.new(@current_user).refresh_connection(@connection_id)
    update_connections_dependencies_data
  end

  private

  def update_connections_dependencies_data
    if last_attempt_finished?
      ImportFromApiGateway::AccountsAndDependencies.new(@current_user, @connection_id).process
    else
      update_connections_dependencies_data
    end
  end

  def last_attempt_finished?
    response = ApiGateway::Connection.new(@current_user).show(@connection_id)
    JSON.parse(response.body).deep_symbolize_keys.dig(:data, :last_attempt, :finished)
  end
end
