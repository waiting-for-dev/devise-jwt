# Devise::JWT

[![Code Climate](https://codeclimate.com/github/waiting-for-dev/devise-jwt/badges/gpa.svg)](https://codeclimate.com/github/waiting-for-dev/devise-jwt)
[![Test Coverage](https://codeclimate.com/github/waiting-for-dev/devise-jwt/badges/coverage.svg)](https://codeclimate.com/github/waiting-for-dev/devise-jwt/coverage)
[![Issue Count](https://codeclimate.com/github/waiting-for-dev/devise-jwt/badges/issue_count.svg)](https://codeclimate.com/github/waiting-for-dev/devise-jwt)

`devise-jwt` is a [devise](https://github.com/plataformatec/devise) extension which uses [JWT](https://jwt.io/) tokens for user authentication. It follows [secure by default](https://en.wikipedia.org/wiki/Secure_by_default) principle.

You can read about which security concerns this library takes into account and about JWT generic secure usage in the following series of posts:

- [Stand Up for JWT Revocation](http://waiting-for-dev.github.io/blog/2017/01/23/stand_up_for_jwt_revocation/)
- [JWT Recovation Strategies](http://waiting-for-dev.github.io/blog/2017/01/24/jwt_revocation_strategies/)
- [JWT Secure Usage](http://waiting-for-dev.github.io/blog/2017/01/25/jwt_secure_usage/)
- [A secure JWT authentication implementation for Rack and Rails](http://waiting-for-dev.github.io/blog/2017/01/26/a_secure_jwt_authentication_for_rack_and_rails)

`devise-jwt` is just a thin layer on top of [`warden-jwt_auth`](https://github.com/waiting-for-dev/warden-jwt_auth) that configures it to be used out of the box with devise and Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise-jwt', '~> 0.1.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise-jwt

## Usage

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

- A user authenticates trough devise create session request (for example, using the standard `:database_authenticatable` module).
- If the authentication succeeds, a JWT token is dispatched to the client in the `Authorization` response header, with format `Bearer #{token}`
- The client can use this token to authenticate following requests for the same user, providing it in the `Authorization` request header, also with format `Bearer #{token}`
- When the client visits devise destroy session request, the token is revoked.

As you see, unlike other JWT authentication libraries, it is expected that tokens will be revoked by the server. I wrote about [why I think JWT revocation is needed and useful](http://waiting-for-dev.github.io/blog/2017/01/23/stand_up_for_jwt_revocation/).

An example configuration:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: Blacklist
end
```

If you need to add something to the JWT payload, you can do it defining a `jwt_payload` method in the user model. It must return a `Hash`. For instance:

```ruby
def jwt_payload
  { 'foo' => 'bar' }
end
```

### Revocation strategies

`devise-jwt` comes with two revocation strategies out of the box. They are implementations of what is discussed in the blog post [JWT Recovation Strategies](http://waiting-for-dev.github.io/blog/2017/01/24/jwt_revocation_strategies/), where I also talk about their pros and cons.

#### JTIMatcher

Here, the model class acts itself as the revocation strategy. It needs a new string column with name `jti` to be added to the user. `jti` stands for JWT ID, and it is a standard claim meant to uniquely identify a token.

It works like the following:

- At the same time that a token is dispatched for a user, the `jti` claim is persisted to the `jti` column.
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
         jwt_revocation_strategy: self
end
```

Be aware that this strategy makes uses of `jwt_payload` method in the user model, so if you need to use it don't forget to call `super`:

```ruby
def jwt_payload
  super.merge('foo' => 'bar')
end
```

#### Blacklist

In this strategy, a database table is used as a blacklist of revoked JWT tokens. The `jti` claim, which uniquely identifies a token, is persisted.

In order to use it, you need to create the blacklist table in a migration:

```ruby
def change
  create_table :jwt_blacklist do |t|
    t.string :jti, null: false
  end
  add_index :jwt_blacklist, :jti
end
```

For performance reasons, it is better if the `jti` column is an index.

Then, you need to create the corresponding model and include the strategy:

```ruby
class JWTBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Blacklist

  self.table_name = 'jwt_blacklist'
end
```

Last, configure the user model to use it:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable,
         jwt_revocation_strategy: JWTBlacklist
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


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
