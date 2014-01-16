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
rdstation = RDStation::Client.new('my_awesome_token')
rdstation.create_lead({name: 'Lead from API', email: 'api@lead.com'})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Reference

You can check out RDstation's integration (pt-BR) documentation here:

- [Pure HTML](https://gist.github.com/pedrobachiega/3298970);
- [Wordpress & Contact Form 7](https://gist.github.com/pedrobachiega/3277536);
- [PHP](https://gist.github.com/pedrobachiega/3248293);
- [HTML+Ajax with jQuery](https://gist.github.com/pedrobachiega/3248013);
