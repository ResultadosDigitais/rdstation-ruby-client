# RDStation Ruby Client

RDstation ruby wrapper to interact with RDStation API.

## Installation

Add this line to your application's Gemfile:

    gem 'rdstation-ruby-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rdstation-ruby-client

## Usage

### Creating a Lead

```ruby
lead_info = {
  email: 'joe@foo.bar',
  name: 'Joe foo',
  empresa: 'A random Company',
  cargo: 'Developer',
  identificador: 'nome_da_conversao'
}

rdstation_client = RDStation::Client.new('rdstation_token', 'auth_token')
rdstation_client.create_lead(lead_info)
```

### Changing a Lead

```ruby
rdstation_client = RDStation::Client.new('rdstation_token', 'auth_token')
rdstation_client.change_lead('joe@foo.bar', lifecycle_stage: 1, opportunity: true})
```

### Change Lead Status

```ruby
rdstation_client = RDStation::Client.new('rdstation_token', 'auth_token')
rdstation_client.change_lead_status(email: 'joe@foo.bar', status: 'won', value: 999)
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Maintainer
[Nando Sousa](mailto:fernando.sousa@resultadosdigitais.com.br)

## Reference

You can check out RDstation's integration (pt-BR) documentation here:

- [Pure HTML](https://gist.github.com/pedrobachiega/3298970);
- [Wordpress & Contact Form 7](https://gist.github.com/pedrobachiega/3277536);
- [PHP](https://gist.github.com/pedrobachiega/3248293);
- [HTML+Ajax with jQuery](https://gist.github.com/pedrobachiega/3248013);
