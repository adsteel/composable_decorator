module ComposableDecorator
  module DSL
    def self.extended(mod)
      mod.define_delegation_params
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
      define_delegation_params(
        associations: associations,
        prefix: prefix,
        allow_nil: allow_nil,
        handle_nil_with: handle_nil_with)
    end

    def define_delegation_params(associations: [], prefix: true, allow_nil: true, handle_nil_with: '')
      define_method(:delegate_decorated_associations) { associations }
      define_method(:delegate_decorated_prefix) { prefix }
      define_method(:delegate_decorated_allow_nil) { allow_nil }
      define_method(:delegate_decorated_handle_nil_with) { handle_nil_with }
    end
  end
end
