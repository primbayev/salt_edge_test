class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    customer = ApiGateway::Customer.new(resource).create
    customer_id = customer.id

    connect_session = ApiGateway::Connection
                        .new(resource)
                        .create_connect_session(customer, connections_create_url)
    connect_url = JSON.parse(connect_session.body).deep_symbolize_keys[:data][:connect_url]

    session["connect_url_#{customer_id}"] = connect_url
    connect_sessions_external_connect_show_path(customer_id: customer_id)
  end
end
