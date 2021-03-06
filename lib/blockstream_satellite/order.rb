require 'faraday'
require 'faraday_middleware'
require "active_support/core_ext/hash/indifferent_access"
require 'tempfile'
require 'securerandom'

module BlockstreamSatellite
  class Order

    attr_accessor :attributes, :file

    def initialize(attributes)
      self.attributes = attributes.with_indifferent_access
    end

    # defining accessors
    [:auth_token, :uuid, :lightning_invoice, :sha256_message_digest, :message_digest, :status, :bid, :unpaid_bid].each do |attr|
      define_method(attr) do
        self.attributes[attr]
      end
    end

    def payreq
      lightning_invoice['payreq']
    end

    def self.create(options)
      if path = options.delete(:path)
        options[:file] = UploadIO.new(options[:file], 'text/plain') # TODO: get rid of this content type here
        options[:file] = File.open(path)
      end
      options[:bid] ||= (options[:file] || options[:message]).size * 51 # default price
      response = BlockstreamSatellite.client.post('order', options)
      if response.success?
        Order.new(response.body).tap { |o| o.file = options[:file] }
      else
        response
      end
    end

    def self.get(order)
      Order.new(order).tap do |o|
        o.refresh
      end
    end

    def refresh
      response = BlockstreamSatellite.client.get("order/#{self.uuid}") do |req|
        req.headers['X-Auth-Token'] = self.auth_token
      end
      if response.success?
        self.attributes.merge!(response.body)
      end
    end

    def pay
      response = BlockstreamSatellite.client.pay(self.payreq)
      if response.payment_error == ''
        self.refresh
      else
        response
      end
    end

    def bump(bid_increase)
      response = BlockstreamSatellite.client.post("order/#{self.uuid}/bump", bid_increase: bid_increase) do |req|
        req.headers['X-Auth-Token'] = self.auth_token
      end
      if response.success?
        self.attributes['lightning_invoice'] = response['lightning_invoice']
      else
        response
      end
    end

  end
end
