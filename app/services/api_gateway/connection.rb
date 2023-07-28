module ApiGateway
  class Connection < Base
    def show(connection_salt_edge_id)
      retries ||= 0

      @response = Faraday.new(
        headers: headers
      ).get("#{@base_url}/connections/#{connection_salt_edge_id}")
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("#{e.class}: #{e.message} --- Retrying request")

      if (retries += 1) <= RETRY_LIMIT
        retry
      else
        raise e
      end
    end

    def list(customer_salt_edge_id)
      retries ||= 0

      @response = Faraday.new(
        params: { customer_id: customer_salt_edge_id },
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

    def create_connect_session(customer)
      retries ||= 0

      @response = Faraday.new(
        headers: headers
      ).post("#{@base_url}/connect_sessions/create") do |req|
        req.body = {
          data: {
            customer_id: customer.salt_edge_id,
            return_connection_id: true,
            include_fake_providers: true,
            consent: {
              from_date: (DateTime.now - 90.days).strftime("%Y-%m-%d"),
              scopes: %w[account_details transactions_details]
            },
            attempt: {
              fetch_scopes: %w[accounts transactions],
              return_to: "http://localhost:3000/connections/create"
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
