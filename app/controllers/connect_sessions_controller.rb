class ConnectSessionsController < ApplicationController
  def external_connect_show
    after_sign_in_path_for(current_user) if is_navigational_format?

    @create_connection_url = session["connect_url_#{params[:customer_id]}"]
    render 'external_connect_show', locals: { create_connection_url: @create_connection_url }
  end

  def reconnect
    connection = ::Connection.find(params[:connection_id])
    connect_session = ApiGateway::Connection
                        .new(current_user)
                        .create_reconnect_session(connection, connections_create_url)

    customer_id = connection.customer.id
    connect_url = JSON.parse(connect_session.body).deep_symbolize_keys[:data][:connect_url]
    session["connect_url_#{customer_id}"] = connect_url

    redirect_to connect_sessions_external_connect_show_path(customer_id: customer_id)
  end
end
