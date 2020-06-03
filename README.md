# Devise::JWT

[![Gem Version](https://badge.fury.io/rb/devise-jwt.svg)](https://badge.fury.io/rb/devise-jwt)
[![Build Status](https://travis-ci.org/waiting-for-dev/devise-jwt.svg?branch=master)](https://travis-ci.org/waiting-for-dev/devise-jwt)
[![Code Climate](https://codeclimate.com/github/waiting-for-dev/devise-jwt/badges/gpa.svg)](https://codeclimate.com/github/waiting-for-dev/devise-jwt)
[![Test Coverage](https://codeclimate.com/github/waiting-for-dev/devise-jwt/badges/coverage.svg)](https://codeclimate.com/github/waiting-for-dev/devise-jwt/coverage)

`devise-jwt` is a [devise](https://github.com/plataformatec/devise) extension which uses [JWT](https://jwt.io/) tokens for user authentication. It follows [secure by default](https://en.wikipedia.org/wiki/Secure_by_default) principle.

This gem is just a replacement for cookies when these can't be used. As
cookies, a token expired with `devise-jwt` will mandatorily have an expiration
time. If you need that your users never sign out, you will be better off with a
solution using refresh tokens, like some implementation of OAuth2.

You can read about which security concerns this library takes into account and about JWT generic secure usage in the following series of posts:

- [Stand Up for JWT Revocation](http://waiting-for-dev.github.io/blog/2017/01/23/stand_up_for_jwt_revocation/)
- [JWT Revocation Strategies](http://waiting-for-dev.github.io/blog/2017/01/24/jwt_revocation_strategies/)
- [JWT Secure Usage](http://waiting-for-dev.github.io/blog/2017/01/25/jwt_secure_usage/)
- [A secure JWT authentication implementation for Rack and Rails](http://waiting-for-dev.github.io/blog/2017/01/26/a_secure_jwt_authentication_implementation_for_rack_and_rails/)

`devise-jwt` is just a thin layer on top of [`warden-jwt_auth`](https://github.com/waiting-for-dev/warden-jwt_auth) that configures it to be used out of the box with devise and Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise-jwt', '~> 0.6.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise-jwt

## Usage

First you need to configure devise to work in an API application. You can follow the instructions in this project wiki page [Configuring devise for APIs](https://github.com/waiting-for-dev/devise-jwt/wiki/Configuring-devise-for-APIs) (you are more than welcome to improve them).

### Secret key configuration

First of all, you have to configure the secret key that will be used to sign generated tokens. You can do it in the devise initializer:

```ruby
Devise.setup do |config|
  # ...
  config.jwt do |jwt|
    jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
  end
end
```

**Important:** You are encouraged to use a secret different than your application `secret_key_base`. It is quite possible that some other component of your system is already using it. If several components share the same secret key, chances that a vulnerability in one of them has a wider impact increase. In rails, generating new secrets is as easy as `bundle exec rake secret`. Also, never share your secrets pushing it to a remote repository, you are better off using an environment variable like in the example.

Currently, HS256 algorithm is the one in use.

### Model configuration

You have to tell which user models you want to be able to authenticate with JWT tokens. For them, the authentication process will be like this:

- A user authenticates through devise create session request (for example, using the standard `:database_authenticatable` module).
- If the authentication succeeds, a JWT token is dispatched to the client in the `Authorization` response header, with format `Bearer #{token}` (tokens are also dispatched on a successful sign up).
- The client can use this token to authenticate following requests for the same user, providing it in the `Authorization` request header, also with format `Bearer #{token}`
- When the client visits devise destroy session request, the token is revoked.

See [request_formats](#request_formats) configuration option if you are using paths with a format segment (like `.json`) in order to use it properly.

As you see, unlike other JWT authentication libraries, it is expected that tokens will be revoked by the server. I wrote about [why I think JWT revocation is needed and useful](http://waiting-for-dev.github.io/blog/2017/01/23/stand_up_for_jwt_revocation/).

An example configuration:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: Denylist
end
```

If you need to add something to the JWT payload, you can do it defining a `jwt_payload` method in the user model. It must return a `Hash`. For instance:

```ruby
def jwt_payload
  { 'foo' => 'bar' }
end
```

You can add a hook method `on_jwt_dispatch` on the user model. It is executed when a token dispatched for that user instance, and it takes `token` and `payload` as parameters.

```ruby
def on_jwt_dispatch(token, payload)
  do_something(token, payload)
end
```

Note: if you are making cross-domain requests, make sure that you add `Authorization` header to the list of allowed request headers and exposed response headers. You can use something like [rack-cors](https://github.com/cyu/rack-cors) for that, for example:

```ruby
config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://your.frontend.domain.com'
    resource '/api/*',
      headers: %w(Authorization),
      methods: :any,
      expose: %w(Authorization),
      max_age: 600
  end
end
```

#### Session storage caveat

If you are working with a Rails application that has session storage enabled
and a default devise setup, chances are that same origin requests will be
authenticated from the session regardless of a token being present in the
headers or not.

This is so because of the following default devise workflow:

- When a user signs in with `:database_authenticatable` strategy, the user is
  stored in the session unless one of the following conditions is met:
  - Session is disabled.
  - Devise `config.skip_session_storage` includes `:params_auth`.
  - [Rails Request forgery
    protection](http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection.html)
    handles an unverified request (but this is usually deactivated for API
    requests).
- Warden (the engine below devise), authenticates any request that has the user
  in the session without even reaching to any strategy (`:jwt_authenticatable`
  in our case).

So, if you want to avoid this caveat you have three options:

- Disable the session. If you are developing an API, probably you don't need
  it. In order to disable it, change `config/initializers/session_store.rb` to:
  ```ruby
  Rails.application.config.session_store :disabled
  ```
  Notice that if you created the application with the `--api` flag you already
  have the session disabled.
- If you still need the session for any other purpose, disable
  `:database_authenticatable` user storage. In `config/initializers/devise.rb`:
  ```ruby
  config.skip_session_storage = [:http_auth, :params_auth]
  ```
- If you are using Devise for another model (e.g. `AdminUser`) and doesn't want
  to disable session storage for devise entirely, you can disable it on a
  per-model basis:
  ```ruby
  class User < ApplicationRecord
    devise :database_authenticatable #, your other enabled modules...
    self.skip_session_storage = [:http_auth, :params_auth]
  end
  ```

### Revocation strategies

`devise-jwt` comes with three revocation strategies out of the box. Some of them are implementations of what is discussed in the blog post [JWT Revocation Strategies](http://waiting-for-dev.github.io/blog/2017/01/24/jwt_revocation_strategies/), where I also talk about their pros and cons.

#### JTIMatcher

Here, the model class acts itself as the revocation strategy. It needs a new string column with name `jti` to be added to the user. `jti` stands for JWT ID, and it is a standard claim meant to uniquely identify a token.

It works like the following:

- When a token is dispatched for a user, the `jti` claim is taken from the `jti` column in the model (which has been initialized when the record has been created).
- At every authenticated action, the incoming token `jti` claim is matched against the `jti` column for that user. The authentication only succeeds if they are the same.
- When the user requests to sign out its `jti` column changes, so that provided token won't be valid anymore.

In order to use it, you need to add the `jti` column to the user model. So, you have to set something like the following in a migration:

```ruby
def change
  add_column :users, :jti, :string, null: false
  add_index :users, :jti, unique: true
  # If you already have user records, you will need to initialize its `jti` column before setting it to not nullable. Your migration will look this way:
  # add_column :users, :jti, :string
  # User.all.each { |user| user.update_column(:jti, SecureRandom.uuid) }
  # change_column_null :users, :jti, false
  # add_index :users, :jti, unique: true
end
```

**Important:** You are encouraged to set a unique index in the `jti` column. This way we can be sure at the database level that there aren't two valid tokens with same `jti` at the same time.

Then, you have to add the strategy to the model class and configure it accordingly:

```ruby
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
```

Be aware that this strategy makes uses of `jwt_payload` method in the user model, so if you need to use it don't forget to call `super`:

```ruby
def jwt_payload
  super.merge('foo' => 'bar')
end
```

#### Denylist

In this strategy, a database table is used as a list of revoked JWT tokens. The `jti` claim, which uniquely identifies a token, is persisted. The `exp` claim is also stored to allow the clean-up of staled tokens.

In order to use it, you need to create the denylist table in a migration:

```ruby
def change
  create_table :jwt_denylist do |t|
    t.string :jti, null: false
    t.datetime :exp, null: false
  end
  add_index :jwt_denylist, :jti
end
```
For performance reasons, it is better if the `jti` column is an index.

Note: if you used the denylist strategy before vesion 0.4.0 you may not have the field *exp.* If not, run the following migration:

```ruby
class AddExpirationTimeToJWTDenylist < ActiveRecord::Migration
  def change
    add_column :jwt_denylist, :exp, :datetime, null: false
  end
end

```

Then, you need to create the corresponding model and include the strategy:

```ruby
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylist'
end
```

Last, configure the user model to use it:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
end
```

#### Allowlist

Here, the model itself acts also as a revocation strategy, but it needs to have
a one-to-many association with another table which stores the tokens (in fact
their `jti` claim, which uniquely identifies them) valids for each user record.

The workflow is as the following:

- Once a token is dispatched for a user, its `jti` claim is stored in the
  associated table.
- At every authentication, the incoming token `jti` is matched against all the
  `jti` associated to that user. The authentication only succeeds if one of
  them matches.
- On a sign out, the token `jti` is deleted from the associated table.

In fact, besides the `jti` claim, the `aud` claim is also stored and matched at
every authentication. This, together with the [aud_header](#aud_header)
configuration parameter, can be used to differentiate between clients or
devices for the same user.

The `exp` claim is also stored to allow the clean-up of staled tokens.

In order to use it, you have to create yourself the associated table and model.
The association table must be called `allowlisted_jwts`:

```ruby
def change
  create_table :allowlisted_jwts do |t|
    t.string :jti, null: false
    t.string :aud
    # If you want to leverage the `aud` claim, add to it a `NOT NULL` constraint:
    # t.string :aud, null: false
    t.datetime :exp, null: false
    t.references :your_user_table, foreign_key: { on_delete: :cascade }, null: false
  end

  add_index :allowlisted_jwts, :jti, unique: true
end
```
Important: You are encouraged to set a unique index in the jti column. This way we can be sure at the database level that there aren't two valid tokens with same jti at the same time. Definining `foreign_key: { on_delete: :cascade }, null: false` on `t.references :your_user_table` helps to keep referential integrity of your database.

And then, the model:

```ruby
class AllowlistedJwt < ApplicationRecord
end
```

Finally, include the strategy in the model and configure it:

```ruby
class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist

  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
end
```

Be aware that this strategy makes uses of `on_jwt_dispatch` method in the user model, so if you need to use it don't forget to call `super`:

```ruby
def on_jwt_dispatch(token, payload)
  super
  do_something(token, payload)
end
```

#### Null strategy

A [null object pattern](https://en.wikipedia.org/wiki/Null_Object_pattern) strategy, which does not revoke tokens, is provided out of the box just in case you are absolutely sure you don't need token revocation. It is recommended **not to use it**.

```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
end
```

#### Custom strategies

You can also implement your own strategies. They just need to implement two methods: `jwt_revoked?` and `revoke_jwt`, both of them accepting as parameters the JWT payload and the user record, in this order.

For instance:

```ruby
module MyCustomStrategy
  def self.jwt_revoked?(payload, user)
    # Does something to check whether the JWT token is revoked for given user
  end

  def self.revoke_jwt(payload, user)
    # Does something to revoke the JWT token for given user
  end
end

class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: MyCustomStrategy
end
```

### Testing

Models configured with `:jwt_authenticatable` usually won't be retrieved from
the session. For this reason, `sign_in` devise testing helper methods won't
work as expected.

What you need to do in order to authenticate test environment requests is the
same that you will do in production: to provide a valid token in the
`Authorization` header (in the form of `Bearer #{token}`) at every request.

There are two ways you can get a valid token:

- Inspecting the `Authorization` response header after a valid sign in request.
- Manually creating it.

The first option tests the real workflow of your application, but it can slow
things if you perform it at every test.

For the second option, a test helper is provided in order to add the
`Authorization` name/value pair to given request headers. You can use it as in
the following example:

```ruby
# First, require the helper module
require 'devise/jwt/test_helpers'

# ...

  it 'tests something' do
    user = fetch_my_user()
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # This will add a valid token for `user` in the `Authorization` header
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

    get '/my/end_point', headers: auth_headers

    expect_something()
  end
```

Usually you will wrap this in your own test helper.

### Configuration reference

This library can be configured calling `jwt` on devise config object:

```ruby
Devise.setup do |config|
  config.jwt do |jwt|
    # ...
  end
end
```
#### secret

Secret key used to sign generated JWT tokens. You must set it.

#### expiration_time

Number of seconds while a JWT is valid after its generation. After that, it won't be valid anymore, even if it hasn't been revoked.

Defaults to 3600 (1 hour).

#### dispatch_requests

Besides the create session one, additional requests where JWT tokens should be dispatched.

It must be a bidimensional array, each item being an array of two elements: the request method and a regular expression that must match the request path.

For example:

```ruby
jwt.dispatch_requests = [
                          ['POST', %r{^/dispatch_path_1$}],
                          ['GET', %r{^/dispatch_path_2$}],
                        ]
```

**Important**: You are encouraged to delimit your regular expression with `^` and `$` to avoid unintentional matches.

#### revocation_requests

Besides the destroy session one, additional requests where JWT tokens should be revoked.

It must be a bidimensional array, each item being an array of two elements: the request method and a regular expression that must match the request path.

For example:

```ruby
jwt.revocation_requests = [
                            ['DELETE', %r{^/revocation_path_1$}],
                            ['GET', %r{^/revocation_path_2$}],
                          ]
```

**Important**: You are encouraged to delimit your regular expression with `^` and `$` to avoid unintentional matches.

#### request_formats

Request formats that must be processed (in order to dispatch or revoke tokens).

It must be a hash of devise scopes as keys and an array of request formats as
values. When a scope is not present or if it has a nil item, requests without
format will be taken into account.

For example, with following configuration, `user` scope would dispatch and
revoke tokens in `json` requests (as in `/users/sign_in.json`), while
`admin_user` would do it in `xml` and with no format (as in
`/admin_user/sign_in.xml` and `/admin_user/sign_in`).

```ruby
jwt.request_formats = {
                        user: [:json],
                        admin_user: [nil, :xml]
                      }
```

By default, only requests without format are processed.

#### aud_header

Request header which content will be stored to the `aud` claim in the payload.

It is used to validate whether an incoming token was originally issued to the
same client, checking if `aud` and the `aud_header` header value match. If you
don't want to differentiate between clients, you don't need to provide that
header.

**Important:** Be aware that this workflow is not bullet proof. In some
scenarios a user can handcraft the request headers, therefore being able to
impersonate any client. In such cases you could need something more robust,
like an OAuth workflow with client id and client secret.

Defaults to `JWT_AUD`.

## Development

There are docker and docker-compose files configured to create a development environment for this gem. So, if you use Docker you only need to run:

`docker-compose up -d`

An then, for example:

`docker-compose exec app rspec`

This gem uses [overcommit](https://github.com/brigade/overcommit) to execute some code review engines. If you submit a pull request, it will be executed in the CI process. In order to set it up, you need to do:

```ruby
bundle install --gemfile=.overcommit_gems.rb
overcommit --sign
overcommit --run # To test if it works
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/waiting-for-dev/devise-jwt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Release Policy

`devise-jwt` follows the principles of [semantic versioning](http://semver.org/).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
