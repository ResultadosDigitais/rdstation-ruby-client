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

## Changelog

### 2.0.0

#### Removals

All API methods that were called directly on `RDStation::Client` (ex: `RDStation::Client.new('rdstation_token', 'auth_token').create_lead(lead_info)`) have been removed. See the [upgrading guide](#Upgrading-to-version-2.0.0) for a comprehensive guide on how to upgrade from version 1.2.x.

#### Notable changes

##### RDStation::Client

Now `RDStation::Client` is facade to all available APIs. It needs to be instantiated with an access_token and has accessors to those APIs. Usage examples:

```ruby
  client = RDStation::Client.new((access_token: 'my_token')
  client.contacts.by_uuid('CONTACT_UUID')
  client.webhooks.all
  client.events.create(my_json_payload)
  client.fields.all
```

`RDStation::Contacts`, `RDStation::Events`, `RDStation::Fields` and `RDStation::Webhooks` are not suposed to be instantiated directly anymore. Use `RDStation::Client` to get them instead.

##### Error handling

Now especic errors are raised for each HTTP status:

- `RDStation::Error::BadRequest` (400)
- `RDStation::Error::Unauthorized` (401)
- `RDStation::Error::Forbidden` (403)
- `RDStation::Error::NotFound` (404)
- `RDStation::Error::MethodNotAllowed` (405)
- `RDStation::Error::NotAcceptable` (406)
- `RDStation::Error::Conflict` (409)
- `RDStation::Error::UnsupportedMediaType` (415)
- `RDStation::Error::UnprocessableEntity` (422)
- `RDStation::Error::InternalServerError` (500)
- `RDStation::Error::NotImplemented` (501)
- `RDStation::Error::BadGateway` (502)
- `RDStation::Error::ServiceUnavailable` (503)
- `RDStation::Error::ServerError` (which is returned for 5xx errors different than 500, 501, 502 or 503)

In case of a Bad Request (400), the following speficic errors may be raised (those are subclasses of `RDStation::Error::BadRequest`):
- `RDStation::Error::ConflictingField`
- `RDStation::Error::InvalidEventType`

In cause of Unahtorized (401), the following speficic errors may be raised (those are subclasses of `RDStation::Error::Unauthorized`):
- `RDStation::Error::ExpiredAccessToken`
- `RDStation::Error::ExpiredCodeGrant`
- `RDStation::Error::InvalidCredentials`

#### Dependencies

`rdstation-ruby-client` now requires ruby `>= 2.0.0`.

### 1.2.1 

#### Deprecations

All API methods that were called directly on `RDStation::Client` (ex: `RDStation::Client.new('rdstation_token', 'auth_token').create_lead(lead_info)`) are now deprecated. Those call RDSM's 1.3 API and will be removed in the next release.

## Upgrading guide

### Upgrading to version 2.0.0

TBD

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

You can check out RDstation's integration documentation at our [developers portal](https://developers.rdstation.com).
