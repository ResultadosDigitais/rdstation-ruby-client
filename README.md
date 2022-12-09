[![CircleCI](https://circleci.com/gh/ResultadosDigitais/rdstation-ruby-client.svg?style=svg)](https://circleci.com/gh/ResultadosDigitais/rdstation-ruby-client)

# RDStation Ruby Client

RDstation ruby wrapper to interact with RDStation API.

Upgrading? Check the [migration guide](#Migration-guide) before bumping to a new major version.

## Table of Contents

1. [Installation](#Installation)
2. [Usage](#Usage)
   1. [Configuration](#Configuration)
   2. [Authentication](#Authentication)
   3. [Contacts](#Contacts)
   4. [Events](#Events)
   5. [Fields](#Fields)
   6. [Webhooks](#Webhooks)
   7. [Emails](#Emails)
   8. [Segmentations](#Segmentations)
   9. [Analytics](#Analytics)
   10.[LandingPages](#LandingPages)
   11.[Errors](#Errors)
3. [Changelog](#Changelog)
4. [Migration guide](#Migration-guide)
   1. [Upgrading from 1.2.x to 2.0.0](#Upgrading-from-1.2.x-to-2.0.0)
5. [Contributing](#Contributing)
6. [Maintainers](#Maintainers)
7. [Reference](#Reference)

## Installation

Add this line to your application's Gemfile:

    gem 'rdstation-ruby-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rdstation-ruby-client

## Usage

### Configuration

Before getting youre credentials, you need to configure client_id and client_secret as following:

```ruby
RDStation.configure do |config|
  config.client_id = YOUR_CLIENT_ID
  config.client_secret = YOUR_CLIENT_SECRET
end
```

For details on what `client_id` and `client_secret` are, check the [developers portal](https://developers.rdstation.com/en/authentication).

### Authentication

For more details, check the [developers portal](https://developers.rdstation.com/en/authentication).

#### Getting authentication URL

```ruby
rdstation_authentication = RDStation::Authentication.new

redirect_url = 'https://yourapp.org/auth/callback'
rdstation_authentication.auth_url(redirect_url)
```

#### Getting access_token

You will need the code param that is returned from RD Station to your application after the user confirms the access at the authorization dialog.

```ruby
rdstation_authentication = RDStation::Authentication.new
rdstation_authentication.authenticate(code_returned_from_rdstation)
# => { 'access_token' => '54321', 'expires_in' => 86_400, 'refresh_token' => 'refresh' }
```

#### Updating an expired access_token

```ruby
rdstation_authentication = RDStation::Authentication.new
rdstation_authentication.update_access_token('refresh_token')
```

**NOTE**: This is done automatically when a request fails due to access_token expiration. To keep track of the new token, you have to provide a callback block in configuration. For example:

```ruby
RDStation.configure do |config|
  config.client_id = YOUR_CLIENT_ID
  config.client_secret = YOUR_CLIENT_SECRET
  config.on_access_token_refresh do |authorization|
    # authorization.access_token_expires_in is the time (in seconds for with the token is valid)
    # authorization.access_token is the new token
    # authorization.refresh_token is the existing refresh_token
    #
    # If you are using ActiveRecord, you may want to update the stored access_token, like in the following code:
    MyStoredAuth.where(refresh_token: authorization.refresh_token).update_all(access_token: authorization.access_token)
  end
end
```

#### Revoking an access_token

```ruby
RDStation::Authentication.revoke(access_token: "your token")
```

Note: this will completely remove your credentials from RD Station (`update_access_token` won't work anymore).

### Contacts

#### Getting a Contact by UUID

Returns data about a specific Contact

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.contacts.by_uuid('uuid')
```

More info: https://developers.rdstation.com/pt-BR/reference/contacts#methodGetDetailsuuid

#### Getting a Contact by Email

Returns data about a specific Contact

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.contacts.by_email('email')
```

More info: https://developers.rdstation.com/pt-BR/reference/contacts#methodGetDetailsemail

#### Update a Contact by UUID

Updates the properties of a Contact.

```ruby
contact_info = {
  name: "Joe Foo"
}

client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.contacts.update('uuid', contact_info)
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

client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.contacts.upsert(identifier, identifier_value, contact_info)
```

More info: https://developers.rdstation.com/pt-BR/reference/contacts#methodPatchUpsertDetails

### Events

#### Sending a new event

The events endpoint are responsible for receiving different event types in which RD Station Contacts take part in.

It is possible to send default events to RD Station such as conversion events, lifecycle events and won and lost events. Also, RD Station supports the possibility of receiving different event types, for instance, chat events, ecommerce ones and others.

Check the [developers portal](https://developers.rdstation.com/en/reference/events) to learn about the required payload structure and which events are available.

This creates a new event on RDSM:

```ruby
payload = {} # hash representing the payload
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.events.create(payload)
```

### Fields

Endpoints to [manage Contact Fields](https://developers.rdstation.com/en/reference/fields) information in your RD Station account.

#### List all fields

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.fields.all
```

#### Create a field

```ruby
payload = {} # hash representing the payload
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.fields.create payload
```
Or you can use the new `RDStation::Builder::Field`

```ruby
payload = {} # hash representing the payload
builder = RDStation::Builder::Field.new payload['api_identifier']
builder.data_type(payload['data_type'])
builder.presentation_type(payload['presentation_type'])
builder.name('pt-BR', payload['name'])
builder.label('pt-BR', payload['label'])

client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.fields.create builder.build
```

#### Update a field

```ruby
payload = {} # hash representing the payload
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.fields.update('FIELD_UUID', payload)
```
Or you can use the new `RDStation::Builder::Field`

```ruby
payload = {} # hash representing the payload
builder = RDStation::Builder::Field.new payload['api_identifier']
builder.data_type(payload['data_type'])
builder.presentation_type(payload['presentation_type'])
builder.name('pt-BR', payload['name'])
builder.label('pt-BR', payload['label'])

client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.fields.update('FIELD_UUID', builder.build)
```
#### Deleting a field

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.fields.delete('FIELD_UUID')
```


### Webhooks

Webhooks provide the ability to receive real-time data updates about your contact activity.

Choose to receive data based on certain actions, re-cast or marked as an opportunity, and have all applicable data sent to a URL of your choice. You can then use your own custom application to read, save, and do actions with that data. This is a powerful option that allows you to keep all your data in sync and opens the possibility for all types of integration.

#### List all webhooks

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.webhooks.all
```

#### Getting a webhook by UUID

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.webhooks.by_uuid('WEBHOOK_UUID')
```

#### Creating a webhook

```ruby
payload = {} # payload representing a webhook
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.webhooks.create(payload)
```

The required strucutre of the payload is [described here](https://developers.rdstation.com/en/reference/webhooks#methodPostDetails).

#### Updating a webhook

```ruby
payload = {} # payload representing a webhook
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.webhooks.create('WEBHOOK_UUID', payload)
```

The required strucutre of the payload is [described here](https://developers.rdstation.com/en/reference/webhooks#methodPutDetails).

#### Deleting a webhook

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.webhooks.delete('WEBHOOK_UUID')
```

### Emails
Endpoints to [Email](https://developers.rdstation.com/reference/get_platform-emails) information in your RD Station account.

#### List all emails

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.emails.all
```

#### List emails using query params
```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
query_params = {page_size: 10, page: 1}
client.emails.all(query_params)
```

#### Get email by id

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.emails.by_id(id)
```

### Segmentations
Endpoints to [Segmentation](https://developers.rdstation.com/reference/segmenta%C3%A7%C3%B5es) information in your RD Station account.
#### List all segmentations

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.segmentations.all
```

#### Get the contact list with a specific segmentation

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.segmentations.contacts(segmentation_id)
```
### Analytics
Endpoints to [Analytics](https://developers.rdstation.com/reference/estatisticas) information in your RD Station account.

#### => List all EMAIL MARKETING analytics data
Endpoints to [Analytics - Email marketing](https://developers.rdstation.com/reference/get_platform-analytics-emails) information in your RD Station account.
- NOTE: The query params `start_date`(yyyy-mm-dd)  and `end_date`(yyyy-mm-dd) are required

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
query_params =  { start_date:'2022-11-02', end_date:'2022-11-08' }
client.analytics.email_marketing(query_params)
```

#### => List CONVERSIONS analytics data
Endpoints to [Analytics - Conversions](https://developers.rdstation.com/reference/get_platform-analytics-conversions) information in your RD Station account.
- NOTE: The query params `start_date`(yyyy-mm-dd) and `end_date`(yyyy-mm-dd) are required.

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
query_params =  { start_date:'2022-11-13', end_date:'2022-11-15', assets_type:['LandingPage'] }
client.analytics.conversions(query_params)
```

### LandingPages
Endpoints to [LandingPages](https://developers.rdstation.com/reference/get_platform-landing-pages) information in your RD Station account.
#### List all landing_pages

```ruby
client = RDStation::Client.new(access_token: 'access_token', refresh_token: 'refresh_token')
client.landing_pages.all
```

### Errors

Each endpoint may raise errors accoording to the HTTP response code from RDStation:

- `RDStation::Error::BadRequest` (400)
- `RDStation::Error::Unauthorized` (401)
- `RDStation::Error::Forbidden` (403)
- `RDStation::Error::NotFound` (404)
- `RDStation::Error::MethodNotAllowed` (405)
- `RDStation::Error::NotAcceptable` (406)
- `RDStation::Error::Conflict` (409)
- `RDStation::Error::UnsupportedMediaType` (415)
- `RDStation::Error::UnprocessableEntity` (422)
- `RDStation::Error::TooManyRequests` (429)
- `RDStation::Error::InternalServerError` (500)
- `RDStation::Error::NotImplemented` (501)
- `RDStation::Error::BadGateway` (502)
- `RDStation::Error::ServiceUnavailable` (503)
- `RDStation::Error::ServerError` (which is returned for 5xx errors different than 500, 501, 502 or 503)

In case of a Bad Request (400), the following specific errors may be raised (those are subclasses of `RDStation::Error::BadRequest`):
- `RDStation::Error::ConflictingField`
- `RDStation::Error::InvalidEventType`

In cause of Unauthorized (401), the following specific errors may be raised (those are subclasses of `RDStation::Error::Unauthorized`):
- `RDStation::Error::ExpiredAccessToken`
- `RDStation::Error::ExpiredCodeGrant`
- `RDStation::Error::InvalidCredentials`

Any error class has a `details` method which returns the specific error message and the http_status.

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

## Migration guide

### Upgrading from 1.2.x to 2.0.0

v2.0.0 main change is that it drops support for RDSM's old 1.x API. If you're not familiar with the 2.0 API yet, [check it out](https://developers.rdstation.com) first. Also take a look at [the release notes](CHANGELOG.md#2.0.0), as they explain the changes in greater detail.

So, here is a step-by-step guide on how to upgrade your app:
- Ensure you're using `ruby >= 2.0.0`.
- Remove every direct instantiation of `RDStation::Contacts`, `RDStation::Events`, `RDStation::Fields` and `RDStation::Webhooks` and use `RDStation::Client` to get them instead.
- Replace any call of `RDStation::Client#create_lead`, `RDStation::Client#change_lead` or `RDStation::Client#change_lead_status` with the equivalent method in the [Contacts API](#Contacts).
- Review your error handling, as [more options](CHANGELOG.md#Error-handling) are available now. `http_status` method will always return nil. To get the status now use `error.details[:http_status]` or check the type of the class.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Maintainers

- [Filipe Nascimento](mailto:filipe.nascimento@resultadosdigitais.com.br)
- [João Hornburg](mailto:joao@rdstation.com)

## Reference

You can check out RDstation's integration documentation at our [developers portal](https://developers.rdstation.com).
