require "faraday"
require 'faraday_middleware'

module BlockstreamSatellite
  class Client
    attr_accessor :http_client, :lnd_client

    def initialize(options)
      self.lnd_client = options[:lnd_client]
      self.http_client = options[:http_client]
    end

    def get(path, params = nil, &block)
      request(:get, path, params, &block)
    end

    def post(path, body = nil, &block)
      puts body.inspect
      request(:post, path, nil, body, &block)
    end

    def pay(payreq)
      self.lnd_client.send_payment_sync(Lnrpc::SendRequest.new(payment_request: payreq))
    end

    def request(http_method, path, params=nil, body=nil)
      response = http_client.send(http_method) do |req|
        req.url "/api/#{path}"
        req.params = params if params
        req.body = body if body
        yield req if block_given?
      end
      Response.new(response)
    rescue Faraday::ClientError => error
      return Response.new(error)
    end

  end
end

