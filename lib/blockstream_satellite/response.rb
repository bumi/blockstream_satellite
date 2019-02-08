require "faraday"
module BlockstreamSatellite
  class Response
    attr_accessor :response, :body, :error

    def initialize(response)
      if response.is_a?(Faraday::ClientError)
        @error = response
      else
        @response = response
        @body = response.body
      end
    end

    def success?
      self.error.nil? && !self.response.nil? && self.response.success?
    end

    def [](key)
      self.body[key.to_s]
    end
  end
end
