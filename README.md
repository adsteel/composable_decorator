# ComposableDecorator

A simple, composable decorator for Rails models.

## Example
```ruby
class User < ActiveRecord::Base
  decorate_with NameDecorator, PhoneNumberDecorator
end

@user = User.find(1).decorate
@user.full_name # => "Jane Smith"
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

Decorators are declared as modules.

```ruby
module NameDecorator
  def full_name
    "#{first_Name} #{last_name}"
  end
end
```

A `#decorate_with` method is called in the model that lists the order of decorators to be added to the instance.

```ruby
# /app/models/user.rb
class User < ActiveRecord::Base
  decorate_with NameDecorator, PhoneNumberDecorator
end
```

This is roughly the equivalent of wrapping the instance in first the Name decorator, then the PhoneNumber decorator, i.e.:

```ruby
class User < ActiveRecord::Base
  extend NameDecorator
  extend PhoneNumberDecorator
end
```

We can then decorate the model in the controller and access the decorated methods in the view.

```ruby
# /app/controllers/users_controller.rb
class UsersController
  def show
    ...
    @user.decorate
  end
end

# /app/views/users/show.html.slim
@user.full_name
@user.full_phone_number

```

Decorators are inherited

```ruby
module HatDecorator
  def hat_decorated_method
    "hat decorator method"
  end
end

class Hat < ActiveRecord::Base
  decorate_with HatDecorator
end

class Stetson < Hat
end

Stetson.new.decorate.hat_decorator_method #=> "hat decorator method"
```


### Delegating an association's decorated methods

We can delegate the association's decorated methods to the instance all at once.

```ruby
module AddressDecorator
  def simple_format
    "#{street}, #{city}"
  end
end

class Address < ActiveRecord::Base
  decorate_with AddressDecorator
end

class User
  delegate_decorated_to :address
end

# /app/views/users/show.html.slim
User.find(1).decorate.address_simple_format
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/composable_decorator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

