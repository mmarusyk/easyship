# Easyship

This gem provides a simple client for Easyship, offering accessing to Easyship's
    shipping, tracking, and logistics services directly from Ruby applications.

## Requirements

Before you begin, ensure you have met the following requirements:

- Ruby version 3.0.0 or newer. You can check your Ruby version by running `ruby -v`.
- Bundler installed. You can install Bundler with `gem install bundler`.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add easyship

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install easyship

## Usage

To use the `easyship` gem in your Ruby application, you need to configure it with your API key and then you can start making requests to Easyship's services.

### Configuration

First, configure the gem with your Easyship API key:

If you have to use in a ruby file:
```ruby
require 'easyship'

Easyship.configure do |c|
  c.url = 'api_url'
  c.api_key = 'your_easyship_api_key'
end
```

If you have to use in Rails:
1. Add to `Gemfile`
```ruby
  gem 'easyship'
```

2. Run `bundle i`

3. Create a new file in `config/initializers` directory
```ruby
Easyship.configure do |config|
  config.url = 'api_url'
  config.api_key = 'your_easyship_api_key'
end
```

Configuration supports the next keys: `url`, `api_key`, `per_page`.

### Making Requests
`Easyship::Client` supports the next methods: `get`, `post`, `put`, `delete`.
```ruby
Easyship::Client.instance.get('/2023-01/account')
```

To make post request:
```ruby
payload = {
  origin_country_alpha2: "SG",
  destination_country_alpha2: "US",
  tax_paid_by: "Recipient",
  is_insured: false,
  items: [
    {
      description: "Silk dress",
      sku: "1002541",
      actual_weight: 1.2,
      height: 10,
      width: 15,
      length: 20,
      category: "fashion",
      declared_currency: "SGD",
      declared_customs_value: 100
    }
  ]
}

Easyship::Client.instance.post('/2023-01/shipment', payload)
```

### Handle errors
When using the `easyship` gem in a Rails application, it's important to handle potential errors that may arise during API calls. Here's how you can handle errors gracefully:

1. Wrap your API calls in a `begin-rescue` block.
2. Catch specific errors from the `easyship` gem to handle them accordingly.

For example:

```ruby
begin
  Easyship::Client.instance.post('/2023-01/shipment', payload)
rescue Easyship::Errors::RateLimitError => e
  Rails.logger.error("Easyship Error: #{e.message}")
end
```

### Pagination
The `get` method in the `Easyship::Client` class is designed to support pagination seamlessly when interacting with the Easyship API by passing block of code. This method abstracts the complexity of managing pagination logic, allowing you to retrieve all items across multiple pages with a single method call.

Suppose you want to retrieve a list of shipments that may span multiple pages. Here's how you can use the `get` method:

```ruby
shipments = []

Easyship::Client.instance.get('/2023-01/shipments') do |page|
  shipments.concat(page[:shipments])
end

shipments # Returns all shipments from all pages
```

To setup items perpage, use the key `per_page` in your configuration.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. Then, eun `rake rubocop` to run the rubocop. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmarusyk/easyship. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mmarusyk/easyship/blob/main/CODE_OF_CONDUCT.md). You can find a list of contributors in the [CONTRIBUTORS.md](https://github.com/mmarusyk/easyship/blob/main/CONTRIBUTORS.md) file.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Easyship project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mmarusyk/easyship/blob/main/CODE_OF_CONDUCT.md).
