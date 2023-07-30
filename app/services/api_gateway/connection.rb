module ApiGateway
  class Connection < Base
    def list
      retries ||= 0

      @response = Faraday.new(
        params: { customer_id: @current_user.customer.id },
        headers: headers
      ).get("#{@base_url}/connections")
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("#{e.class}: #{e.message} --- Retrying request")

      if (retries += 1) <= RETRY_LIMIT
        retry
      else
        raise e
      end
    end

    def create_connect_session(customer, return_to_url)
      retries ||= 0

      @response = Faraday.new(
        headers: headers
      ).post("#{@base_url}/connect_sessions/create") do |req|
        req.body = JSON.generate(
          {
            data: {
              customer_id: customer.id,
              return_connection_id: true,
              include_fake_providers: true,
              consent: {
                scopes: %w[account_details transactions_details]
              },
              attempt: {
                fetch_scopes: %w[accounts transactions],
                return_to: return_to_url
              }
            }
          }
        )
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("#{e.class}: #{e.message} --- Retrying request")

      if (retries += 1) <= RETRY_LIMIT
        retry
      else
        raise e
      end
    end

    def create_reconnect_session(connection, return_to_url)
      retries ||= 0

      @response = Faraday.new(
        headers: headers
      ).post("#{@base_url}/connect_sessions/reconnect") do |req|
        req.body = JSON.generate(
          {
            data: {
              connection_id: connection.id,
              consent: {
                scopes: %w[account_details transactions_details]
              },
              attempt: {
                fetch_scopes: %w[accounts transactions],
                return_to: return_to_url
              }
            }
          }
        )
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("#{e.class}: #{e.message} --- Retrying request")

      if (retries += 1) <= RETRY_LIMIT
        retry
      else
        raise e
      end
    end

    def refresh_connection(connection_id)
      retries ||= 0

      @response = Faraday.new(
        headers: headers
      ).put("#{@base_url}/connections/#{connection_id}/refresh") do |req|
        req.body = JSON.generate(
          {
            data: {
              attempt: {
                fetch_scopes: %w[accounts transactions]
              }
            }
          }
        )
      end
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("#{e.class}: #{e.message} --- Retrying request")

      if (retries += 1) <= RETRY_LIMIT
        retry
      else
        raise e
      end
    end

    def show(connection_id)
      retries ||= 0

      @response = Faraday.new(
        headers: headers
      ).get("#{@base_url}/connections/#{connection_id}")
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
