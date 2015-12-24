# Isone
[![Circle CI](https://circleci.com/gh/jwg2s/isone-ruby/tree/develop.svg?style=shield)](https://circleci.com/gh/jwg2s/isone-ruby/tree/develop)
[![Code Climate](https://codeclimate.com/github/jwg2s/isone-ruby/badges/gpa.svg)](https://codeclimate.com/github/jwg2s/isone-ruby)
[![Test Coverage](https://codeclimate.com/github/jwg2s/isone-ruby/badges/coverage.svg)](https://codeclimate.com/github/jwg2s/isone-ruby/coverage)

This is an API Wrapper for ISO NE's API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'isone-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install isone-ruby

## Usage

```ruby
Isone.username = 'username'
Isone.password = 'password'

# Request data for a date and node
Isone::Lmp.new(Date.yesterday, 4475)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jwg2s/isone-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

