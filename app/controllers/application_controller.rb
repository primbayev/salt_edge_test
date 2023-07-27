class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    ApiGateway::Customer.new(resource).create
    root_path
  end
end
