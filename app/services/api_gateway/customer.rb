module ApiGateway
  class Customer < Base
    def create
      retries ||= 0

      @response = Faraday.new(
        headers: headers
      ).post("#{@base_url}/customers") do |req|
        req.body = JSON.generate( { data: { identifier: @current_user.email } } )
      end

      if @current_user.customer
        @current_user.customer
      else
        data = JSON.parse(@response.body).deep_symbolize_keys[:data]

        ::Customer.create(
          id: data[:id],
          user_id: @current_user.id,
          identifier: data[:identifier]
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
  end
end
