module ApiGateway
  class Account < Base
    def show(connection_id)
      retries ||= 0

      @response = Faraday.new(
        params: { connection_id: connection_id },
        headers: headers
      ).get("#{@base_url}/accounts")
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
