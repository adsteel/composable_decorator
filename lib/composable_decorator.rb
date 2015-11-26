require_relative "./composable_decorator/version"

module ComposableDecorator
  module ClassMethods
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

  def self.included(base)
    base.extend ClassMethods

    base.define_delegate_decorated_methods
  end

  def decorate
    add_decorators
    decorate_associations
    delegate_decorated_association_methods

    self
  end

  private def add_decorators
    decorators.each do |decorator|
      extend(decorator)
    end
  end

  private def decorate_associations
    method_delegate_decorated_associations.each do |assoc|
      public_send(assoc).try(:decorate)
    end
  end

  private def delegate_decorated_association_methods
    class_delegate_decorated_associations.each do |klass|
      methods = class_decorated_methods(klass)

      self.class.delegate(
        *methods,
        to: klass.to_s.underscore,
        prefix: delegate_decorated_prefix,
        allow_nil: delegate_decorated_allow_nil)
    end
  end

  private def class_decorated_methods(klass)
    klass.new.decorators.map(&:instance_methods).flatten
  end

  private def class_delegate_decorated_associations
    delegate_decorated_associations.map { |a| a.to_s.camelize.constantize }
  end

  private def method_delegate_decorated_associations
    delegate_decorated_associations
  end
end
