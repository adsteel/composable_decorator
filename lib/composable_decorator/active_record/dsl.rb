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
        define_method(:decorators) { decorators }
      end
    end
  end
end
