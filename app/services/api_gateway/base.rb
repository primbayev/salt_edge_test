module ApiGateway
  class Base
    RETRY_LIMIT = 5

    def initialize(current_user)
      @current_user = current_user

      rails_credentials = Rails.application.credentials.config
      @app_id = rails_credentials.fetch(:app_id)
      @secret = rails_credentials.fetch(:secret)
      @base_url = rails_credentials.fetch(:base_url)
    end

    def headers
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'App-id' => @app_id,
        'Secret' => @secret
      }
    end
  end
end
