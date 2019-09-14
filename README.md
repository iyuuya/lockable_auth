# LockableAuth

Lock when authentication fails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lockable_auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lockable_auth

## Usage

### Setup

Add `locked_at` and `failed_attempts` columns.

```ruby
rails g lockable_auth:install
```

```ruby
class User < ApplicationRecord
  has_secure_password

  include LockableAuth # Please add after has_secure_password
end
```

### Authenticate

```ruby
user = User.create(email: 'asdf@example.com', password: 'abcd1234', 'abcd1234')
user.authenticate('abcd1234') #=> user

user.authenticate('xxxxyyyy') #=> false and increment failed_attempts
user.authenticate('xxxxyyyy') #=> false
user.authenticate('xxxxyyyy') #=> false
user.authenticate('xxxxyyyy') #=> false
user.authenticate('xxxxyyyy') #=> false and lock
```

### Configuration

```ruby
# Number of authentication tries before locking an account.
User.maximum_attempts = 5 # Default 5. Disable lock when this parameter is 0

# Time interval to unlock the account
User.unlock_in = 1.hour # Default 1 hour. Disable lock when this parameter is 0
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iyuuya/lockable_auth.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
