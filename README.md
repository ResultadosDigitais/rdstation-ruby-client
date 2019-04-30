[![CircleCI](https://circleci.com/gh/ResultadosDigitais/rdstation-ruby-client.svg?style=svg)](https://circleci.com/gh/ResultadosDigitais/rdstation-ruby-client)

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

### Authentication

#### Getting authentication URL

```ruby
rdstation_authentication = RDStation::Authentication.new('client_id', 'client_secret')

redirect_url = 'https://yourapp.org/auth/callback'
rdstation_authentication.auth_url(redirect_url)
```

#### Getting access_token

You will need the code param that is returned from RD Station to your application after the user confirms the access at the authorization dialog.

```ruby
rdstation_authentication = RDStation::Authentication.new('client_id', 'client_secret')
rdstation_authentication.authenticate(code_returned_from_rdstation)
```

#### Updating access_token

```ruby
rdstation_authentication = RDStation::Authentication.new('client_id', 'client_secret')
rdstation_authentication.update_access_token('refresh_token')
```

### Contacts

#### Getting a Contact by UUID

Returns data about a specific Contact

```ruby
contact = RDStation::Contacts.new('auth_token')
contact.by_uuid('uuid')
```

More info: https://developers.rdstation.com/pt-BR/reference/contacts#methodGetDetailsuuid

#### Getting a Contact by Email

Returns data about a specific Contact

```ruby
contact = RDStation::Contacts.new('auth_token')
contact.by_email('email')
```

More info: https://developers.rdstation.com/pt-BR/reference/contacts#methodGetDetailsemail

#### Update a Contact by UUID

Updates the properties of a Contact.

```ruby
contact_info = {
  name: "Joe Foo"
}

contact = RDStation::Contacts.new('auth_token')
contact.update('uuid', contact_info)
```
Contact Default Parameters
 - email
 - name
 - job_title
 - linkedin
 - facebook
 - twitter
 - personal_phone
 - mobile_phone
 - website
 - tags

More info: https://developers.rdstation.com/pt-BR/reference/contacts#methodPatchDetails


#### Upsert a Contact by identifier and value

With an UPSERT like behavior, this method is capable of both updating the properties of a Contact or creating a new Contact. Whatever is used as an identifier cannot appear in the request payload as a field. This will result in a [BAD_REQUEST error](https://developers.rdstation.com/pt-BR/error-states#conflicting).

```ruby
contact_info = {
  name: "Joe Foo"
}

identifier = "email"
identifier_value = "joe@foo.bar"

contact = RDStation::Contacts.new('auth_token')
contact.upsert(identifier, identifier_value, contact_info)
```

More info: https://developers.rdstation.com/pt-BR/reference/contacts#methodPatchUpsertDetails

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Maintainers

- [Nando Sousa](mailto:fernando.sousa@resultadosdigitais.com.br)
- [Filipe Nascimento](mailto:filipe.nascimento@resultadosdigitais.com.br)
- [João Hornburg](mailto:joao@rdstation.com)

## Reference

You can check out RDstation's integration (pt-BR) documentation here:

- [Pure HTML](https://gist.github.com/pedrobachiega/3298970);
- [Wordpress & Contact Form 7](https://gist.github.com/pedrobachiega/3277536);
- [PHP](https://gist.github.com/pedrobachiega/3248293);
- [HTML+Ajax with jQuery](https://gist.github.com/pedrobachiega/3248013);
