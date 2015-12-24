require_relative './dsl'

module ComposableDecorator
  module ActiveRecord
    module Base
      def self.included(mod)
        mod.extend DSL

        mod.__define_delegation
        mod.__initialize_decorators
      end

      def decorate
        __add_decorators
        __decorate_associations
        __delegate_decorated_association_methods

        self
      end

      private def __add_decorators
        __decorators.each do |decorator|
          extend(decorator)
        end
      end

      private def __decorate_associations
        __associations.each do |assoc|
          public_send(assoc).try(:decorate)
        end
      end

      private def __delegate_decorated_association_methods
        __associations.each do |assoc|
          methods = __decorator_methods(assoc)

          self.class.delegate(
            *methods,
            to: assoc,
            prefix: __prefix,
            allow_nil: __allow_nil)
        end
      end

      private def __decorators
        self.class.__decorators
      end

      private def __associations
        self.class.__associations
      end

      private def __decorator_methods(assoc)
        __association_class(assoc).__decorators.map(&:instance_methods).flatten
      end

      private def __association_class(assoc)
        self.class.reflect_on_association(assoc).klass
      end
    end
  end
end
