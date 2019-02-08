require "blockstream_satellite/version"

require 'lnrpc'

module BlockstreamSatellite
  class Error < StandardError; end
  autoload :Order, 'blockstream_satellite/order'
  autoload :Client, 'blockstream_satellite/client'
  autoload :Configuration, 'blockstream_satellite/configuration'
  autoload :Response, 'blockstream_satellite/response'

  API_HOST = 'https://satellite.blockstream.com'

  def self.lnd_client=(value)
    @lnd_client = value
  end

  def self.lnd_client
    @lnd_client ||= Lnrpc::Client.new({})
  end

  def http_client=(value)
    @http_client = value
  end

  def self.http_client
    @http_client ||= Faraday.new(url: API_HOST) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      faraday.response :json, :content_type => /\bjson$/

      faraday.adapter Faraday.default_adapter
    end
  end

  def self.client
    @client ||= Client.new(lnd_client: self.lnd_client, http_client: self.http_client)
  end

  def self.info
    self.client.get('/info')
  end

end
BSat = BlockstreamSatellite
