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
        req.body = {
          data: {
            customer_id: customer.id,
            return_connection_id: true,
            include_fake_providers: true,
            consent: {
              from_date: (DateTime.now - 90.days).strftime("%Y-%m-%d"),
              scopes: %w[account_details transactions_details]
            },
            attempt: {
              fetch_scopes: %w[accounts transactions],
              return_to: return_to_url
            }
          }
        }.to_json
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
        req.body = {
          data: {
            connection_id: connection.id,
            consent: {
              from_date: (DateTime.now - 365.days).strftime("%Y-%m-%d"),
              scopes: %w[account_details transactions_details]
            },
            attempt: {
              fetch_scopes: %w[accounts transactions],
              return_to: return_to_url
            }
          }
        }.to_json
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
        req.body = {
          data: {
            attempt: {
              fetch_scopes: %w[accounts transactions]
            }
          }
        }.to_json
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
