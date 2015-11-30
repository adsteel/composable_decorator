module ComposableDecorator
  module DSL
    # # declares the order of decorators applied to an instance
    # # that calls the #decorate method
    #
    # class AdminUser
    #   decorate_with UserDecorator, AdminDecorator
    #
    # # The above code results in #decorate first decorating the instance
    # # with the UserDecorator, then the AdminDecorator
    #
    # @Param +decorators+ is an <Array> of classes
    def decorate_with(*decorators)
      define_method(:decorators) { decorators }
    end

    # # delegates all of the decorated methods for each association.
    #
    # module PostDecorator
    #   def full_name
    #     "#{name} {created_at}"
    #
    # class Post
    #   decorate_with PostDecorator
    #
    # class Author
    #   has_many :posts
    #   delegate_decorated_to :posts
    #
    # # The above code allows you to call:
    #
    # author.decorate
    # author.post_full_name
    #
    # # Like Rails's #delegate method, you can choose to allow_nil
    # # or to prefix the delegated method. Both default to true.
    #
    # @Param +associations+ is an <Array> of symbols
    def delegate_decorated_to(*associations, prefix: true, allow_nil: true, handle_nil_with: '')
      define_delegate_decorated_methods(
        associations: associations,
        prefix: prefix,
        allow_nil: allow_nil,
        handle_nil_with: handle_nil_with)
    end

    def define_delegate_decorated_methods(associations: [], prefix: true, allow_nil: true, handle_nil_with: '')
      define_method(:delegate_decorated_associations) { associations }
      define_method(:delegate_decorated_prefix) { prefix }
      define_method(:delegate_decorated_allow_nil) { allow_nil }
      define_method(:delegate_decorated_handle_nil_with) { handle_nil_with }
    end
  end
end
