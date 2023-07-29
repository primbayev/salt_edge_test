module ApiGateway
  class Transaction < Base
    def show(connection_id, account_id)
      retries ||= 0

      @response = Faraday.new(
        params: { connection_id: connection_id, account_id: account_id },
        headers: headers
      ).get("#{@base_url}/transactions")
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("#{e.class}: #{e.message} --- Retrying request")

      if (retries += 1) <= RETRY_LIMIT
        retry
      else
        raise e
      end
    end

    def show_pending(connection_id, account_id)
      retries ||= 0

      @response = Faraday.new(
        params: { connection_id: connection_id, account_id: account_id },
        headers: headers
      ).get("#{@base_url}/transactions/pending")
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
