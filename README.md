# BlockstreamSatellite

Ruby gem to interact with the [Blockstream Satellite](https://blockstream.com/satellite/) API.  

To learn more about the Blockstream Satellite check their [website](https://blockstream.com/satellite/) and [API documentation](https://blockstream.com/satellite-api/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blockstream_satellite'
```

Or install it yourself as:

    $ gem install blockstream_satellite


## Usage

### Quick example

```ruby
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
* `data`: data to transmit; can be used as an alternative `path`
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


## Satus

Currently I consider this gem experimental and it is missing tests current.  


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/blockstream_satellite.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
