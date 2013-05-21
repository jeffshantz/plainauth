# PlainAuth

[![Build Status](https://travis-ci.org/jeffshantz/plainauth.png?branch=master)](https://travis-ci.org/jeffshantz/plainauth)

PlainAuth is a simple, drop-in replacement for `ActiveModel::SecurePassword`.
It fixes several validation bugs that currently exist with `has_secure_password`,
and adds a few additional features, such as the ability to

* Specify the `BCrypt` cost -- `has_secure_password` only allows one to toggle
  between the minimum BCrypt cost and the default cost
* Apply password validations after creation, if desired.  This would be useful,
  for instance, in a case where a user is required to reset his/her password.

This gem borrows code heavily from `ActiveModel::SecurePassword` and adds upon
it.  It was created mostly for use within my own projects, but if you find it
useful, feel free to let me know.  It is not, and will never be, however, a 
competitor to heavier-weight libraries like Devise and AuthLogic.  Like
`SecurePassword`, PlainAuth handles only authentication -- plain and simply.

## Installation

Add this line to your application's Gemfile:

    gem 'plainauth'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plainauth

## Usage

In your database migration, add a column `password_digest`,
with a length of 60 characters:

  class CreateUsers < ActiveRecord::Migration
    def change
      create_table :users do |t|
        t.string   :password_digest, null: false, limit: 60
      end
    end
  end

Next, in your model, add `has_plain_auth`.

    class User < ActiveRecord::Base
      has_plain_auth
    end

This will add several methods to your model:

* `password()`
* `password=(newpass)`
* `password_confirmation=(newpass)`
* `resetting_password=(bool)`
* `authenticate(email, password)`

See the example below for details on these methods.

Additionally, several validations will be added to your model:

* On creation, 

  * Ensure that the `password` and `password_confirmation`
    are specified, and that they match

  * If the `min_length` and/or `max_length` options are specified (see
    the next section), validate the length of the password specified
  
  * If the `format` option is specified (next section), validate the 
    format of the password specified

* On update, if `resetting_password` is set to `true`, perform these
  same validations.  This is useful in the event that you are 
  requiring a user to reset his/her password

## Options

`has_plain_auth` accepts several options:

* `min_length`: Minimum acceptable length of a password
* `format`: Regular expression used to validate a password

Observe that there is no `max_length` option.  As developers, our mantra should
be: Don't piss of the user with artificial restrictions.  A maximum password
length is a ridiculous artificial restriction.  I, for example, use 1Password
and generate 30+ character passwords for each of the sites on which I have an
account.  It irritates me to no end when a site restricts my password length to,
say, 8 characters.  Curiously, I find it is usually the banks who do this.

Don't restrict the maximum length of a user's password.  Either way, the
password the user enters is going to be hashed using the BCrypt algorithm to a
60 character digest, so database storage is no excuse.  If you really need to
do this for some reason, you can add a validation yourself to your model.

### Example
 
The following example requires a user to specify a password of at least 6
characters, and one that includes a number, lowercase letter, uppercase
letter, and a symbol.

    class User < ActiveRecord::Base
      has_plain_auth min_length: 6,
                     format: /((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).)/
    end

    # Require a new user to specify and confirm her password
    u = User.new
    u.valid?                           # => false (password can't be blank)
    u.password = "H3ll0!"
    u.valid?                           # => false (password_confirmation doesn't match password)
    u.password_confirmation = "H3ll0!"
    u.valid?                           # => true
    u.save                             # => true

    # Require an existing user to reset her password
    u = User.first
    u.valid?                           # => true
    u.resetting_password = true        
    u.valid?                           # => false (password can't be blank)
    u.password = "Qw3!!!"
    u.password_confirmation = "Qw3!!!" 
    u.valid?                           # => true
    u.save                             # => true

    # Authenticate a user
    u = User.find_by(name: 'kim')
    u.authenticate('badpass')          # => false
    u.authenticate('Qw3!!!')           # => user 

    # More authentication
    User.find_by(name: 'bob').try(:authenticate, 'badpass')  # => false
    User.find_by(name: 'bob').try(:authenticate, 'G0odpa$$') # => user

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
