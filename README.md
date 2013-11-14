# Rdstation::Ruby

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'rdstation-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rdstation-ruby

## Usage

TODO: Write better usage instructions here

### Minimal
```ruby
require 'rdstation-ruby-client'
rdstation = RDStation::Client.new('7910dbb87920c9616cc26f11849356a9')
rdstation.create_lead({name: 'Lead from API', email: 'api@lead.com'})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
