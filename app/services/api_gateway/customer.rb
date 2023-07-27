module ApiGateway
  class Customer < Base
    def create
      retries ||= 0

      @response = Faraday.new(
        headers: {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'App-id' => @app_id,
          'Secret' => @secret
        }
      ).post("#{@base_url}/customers") do |req|
        req.body = { data: { identifier: @current_user.email } }.to_json
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("#{e.class}: #{e.message} --- Retrying request")

      if (retries += 1) <= RETRY_LIMIT
        retry
      else
        raise e
      end
    end
  end
end
