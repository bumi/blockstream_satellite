# Blockstream Satellite - with ruby to space and back

Ruby gem to interact with the [Blockstream Satellite](https://blockstream.com/satellite/) API.  

To learn more about the Blockstream Satellite check their [website](https://blockstream.com/satellite/) and [API documentation](https://blockstream.com/satellite-api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blockstream_satellite'
```

Or install it yourself as:

    $ gem install blockstream_satellite

**Because of an [protobuf issue with Ruby 2.6](https://github.com/protocolbuffers/protobuf/issues/5161) a ruby version < 2.6 is required**


## Usage

### Quick example

```ruby
require "blockstream_satellite"

order = BlockstreamSatellite::Order.create(path: '/path/to/file')
puts order.status # pending
order.pay # sends the lightning payment using the configured lnd client; request is synchronous

puts order.status # transmitting
order.refresh
puts order.status # sent
```

### Configuration

In order to be able to pay for the lightninig invoice you need to connect to you lightning node.  
(By default the testnet cert and macaroon files are loaded from `~/.lnd` and `localhost:10009` is used)

```ruby
lnd_client = Lnrpc::Client.new({
  credentials_path: '/path/to/tls.cert', 
  macaroon_path: '/path/to/admin.macaroon', 
  address: 'localhost:10009'
})
BlockstreamSatellite.lnd_client = lnd_client
```

### Creating an order

`BlockstreamSatellite::Order.create` accepts the following parameters: 

* `path`: path to the file to transmit
* `message`: message to transmit; can be used as an alternative `path`
* `bid`: bid for the order. defaults to file size * 51

```ruby
order = BlockstreamSatellite::Order.create(path: '/path/to/file')
```

### Loading an order by UUID and auth_token

```ruby
order = BlockstreamSatellite::Order.get(uuid: 'uuid', auth_token: 'auth_token')
```

### Bump the bid for an order

```ruby
order = BlockstreamSatellite::Order.get(uuid: 'uuid', auth_token: 'auth_token')
order.bump(1000)
```

### Pay for an order

```ruby
order = BlockstreamSatellite::Order.get(uuid: 'uuid', auth_token: 'auth_token')
# or
order = BlockstreamSatellite::Order.create(path: '/path/to/file')

order.pay
puts order.status
```

### Missing endpoints: 

* DELETE /order/:uuid
* GET /orders/queued
* GET /orders/sent
* GET /subscribe/:channels

## Status

Currently I consider this gem **experimental** and the codes needs cleanup and tests and docs are missing at this moment. 
Will try to get is stable soon! 


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bumi/blockstream_satellite.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
