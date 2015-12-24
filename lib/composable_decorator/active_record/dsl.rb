module ComposableDecorator
  module ActiveRecord
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
        existing_decorators = defined?(__decorators) ? __decorators : []

        define_singleton_method(:__decorators) { decorators + existing_decorators }
      end

      # # delegates all of the decorated methods for each has_one or belongs_to association.
      #
      # module PostDecorator
      #   delegate_decorated_to :author
      #
      #   def full_name
      #     "#{name} {created_at}"
      #
      # class Post
      #   belongs_to :author
      #   decorate_with PostDecorator
      #
      # # The above code allows you to call:
      #
      # post.decorate
      # post.author_full_name
      #
      # # Like Rails's #delegate method, you can choose to allow_nil
      # # or to prefix the delegated method. Both default to true.
      #
      # @Param +associations+ is an <Array> of symbols
      def delegate_decorated_to(*associations, prefix: true, allow_nil: true, handle_nil_with: '')
        __define_delegation(
          associations: associations,
          prefix: prefix,
          allow_nil: allow_nil,
          handle_nil_with: handle_nil_with)
      end

      def __define_delegation(associations: [], prefix: true, allow_nil: true, handle_nil_with: '')
        define_method(:__associations) { associations }
        define_method(:__prefix) { prefix }
        define_method(:__allow_nil) { allow_nil }
        define_method(:__handle_nil_with) { handle_nil_with }
      end
    end
  end
end
