## 2.4.0

- Add the TooManyRequests errors in case of rate limit exceeded. See [API request limit](https://developers.rdstation.com/en/request-limit) for more details

## 2.3.1

- Fixed a bug when no error is found in the known errors list (issue [#52](https://github.com/ResultadosDigitais/rdstation-ruby-client/issues/52))

## 2.3.0

### Additions

#### 1. New Field methods

The following methods were added to "Fields" client:

- create
- update
- delete

Besides reading, this client is now capable of create, update or delete a field.

Usage example:

```ruby
client = RDStation::Client.new(access_token: 'ACCESS_TOKEN', refresh_token: 'REFRESH_TOKEN')
client.fields.delete('FIELD_UUID')
```

#### 2. New format of errors supported

Two new formats of errors are now supported by the error handler:

##### `HASH_OF_HASHES`

When the error message is a hash containing other hashes as values, for example:

```ruby
{
  'error' => {
    'field1' => {...},
    'field2' => {...}
  }
}
```

##### `HASH_OF_MULTIPLE_TYPES`

When the error message is a hash that could contain multiple data types as values, for example:

```ruby
{
  'error' => {
    'field1' => [...] # Array,
    'field2' => {...} # Hash
  }
}
```

## 2.2.0

### Additions

#### Configuration

Now it is possible to configure global params like client_id and client_secret only once, so you don't need to provide them to `RDStation::Authentication` every time.

This can be done in the following way:

```ruby
RDStation.configure do |config|
  config.client_id = YOUR_CLIENT_ID
  config.client_secret = YOUR_CLIENT_SECRET
end
```

If you're using Rails, this can be done in `config/initializers`.

#### Automatic refresh of access_tokens

When an access_token expires, a new one will be obtained automatically and the request will be made again.

For this to work, you have to use `RDStation.configure` as described above, and provide the refresh token when instantiating `RDStation::Client` (ex: RDStation::Client.new(access_token: MY_ACCESS_TOKEN, refresh_token: MY_REFRESH_TOKEN).

You can keep track of access_token changes, by providing a callback block inconfiguration. This block will be called with an `RDStation::Authorization` object, which contains the updated `access_token` and `refresh_token`. For example:

```ruby
RDStation.configure do |config|
  config.on_access_token_refresh do |authorization|
    MyStoredAuth.where(refresh_token: authorization.refresh_token).update_all(access_token: authorization.access_token)
  end
end
```

### Deprecations

Providing `client_id` and `client_secret` directly to `RDStation::Authentication.new` is deprecated and will be removed in future versions. Use `RDStation.configure` instead.

Specifying refresh_token in `RDStation::Client.new(access_token: 'at', refresh_token: 'rt')` is optional right now, but will be mandatory in future versions.

## 2.1.1

- Fixed a bug in error handling (issue [#47](https://github.com/ResultadosDigitais/rdstation-ruby-client/issues/47))

## 2.1.0

### Additions

`RDStation::Authentication.revoke`  added. This method revokes an access_token at RD Station.

## 2.0.0

### Removals

All API methods that were called directly on `RDStation::Client` (ex: `RDStation::Client.new('rdstation_token', 'auth_token').create_lead(lead_info)`) have been removed. See the [migration guide](README.md#Upgrading-from-1.2.x-to-2.0.0) for a comprehensive guide on how to upgrade from version 1.2.x.

### Notable changes

#### RDStation::Client

Now `RDStation::Client` is facade to all available endpoints in the 2.0 API. It needs to be instantiated with an access_token and has accessors to those endpoints. Usage examples:

```ruby
  client = RDStation::Client.new((access_token: 'my_token')
  client.contacts.by_uuid('CONTACT_UUID')
  client.webhooks.all
  client.events.create(my_json_payload)
  client.fields.all
```

`RDStation::Contacts`, `RDStation::Events`, `RDStation::Fields` and `RDStation::Webhooks` are not suposed to be instantiated directly anymore. Use `RDStation::Client` to get them instead.

#### Error handling

Now specific errors are raised for each HTTP status:

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

In case of a Bad Request (400), the following specific errors may be raised (those are subclasses of `RDStation::Error::BadRequest`):
- `RDStation::Error::ConflictingField`
- `RDStation::Error::InvalidEventType`

In cause of Unauthorized (401), the following specific errors may be raised (those are subclasses of `RDStation::Error::Unauthorized`):
- `RDStation::Error::ExpiredAccessToken`
- `RDStation::Error::ExpiredCodeGrant`
- `RDStation::Error::InvalidCredentials`

The specific message and the http code are now returned by the `details` method.

### Dependencies

`rdstation-ruby-client` now requires `ruby >= 2.0.0`.

## 1.2.1

### Deprecations

All API methods that were called directly on `RDStation::Client` (ex: `RDStation::Client.new('rdstation_token', 'auth_token').create_lead(lead_info)`) are now deprecated. Those methods call RDSM's 1.3 API and will be removed in the next release.
