# ComposableDecorator

-- work in progress. I would not rely on this gem yet. --

A simple, composable decorator for Rails models.

## Example
```ruby
class User < ActiveRecord::Base
  include composableDecorator

  decorate_with NameDecorator, PhoneNumberDecorator
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'composable_decorator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install composable_decorator

## Usage

```ruby
# Decorators are declared in the /decorators folder
#
# app/decorators/name.rb
module Name
  def full_name
    "#{first_Name} #{last_name}"
  end
end

module PhoneNumber
  def full_phone_number
    "(#{area_code}) #{phone_number}"
  end
end

# a #decorate method is declared in the model, that lists the order of decorators
# to be called on the instance. The name of this method must be the same across
# multiple models in order to decorate the AR relationships
#
# /app/models/user.rb
class User < ActiveRecord::Base
  include composableDecorator

  decorate_with Name, PhoneNumber
end

# this is roughly the equivalent of wrapping the instance in first the Name decorator,
# then the PhoneNumber decorator, i.e.
class User < ActiveRecord::Base
  extend Name
  extend PhoneNumber
  # more functionality runs here to work with AR relationships
end

# we can then decorate the model in the controller
#
# /app/controllers/users_controller.rb
class UsersController
  def show
    ...
    @user.decorate
  end
end

# and we can access the decorated methods in the view
#
# /app/views/users/show.html.slim
@user.full_name
@user.full_phone_number

# DELEGATIONS
#
# We can delegate the association's decorated methods to the model
class Address < ActiveRecord::Base
  include composableDecorator

  decorate_with AddressDecorator
end

class User
  include composableDecorator

  decorate_with Name, PhoneNumber
  delegate_decorated_to :address
end

# which delegates all the decorated methods created in Address#decorate to User
#
# /app/views/users/show.html.slim
@user.address_simple_format
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/composable_decorator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

