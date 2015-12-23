require_relative './dsl'

module ComposableDecorator
  module ActiveRecord
    module Base
      def self.included(mod)
        mod.extend DSL

        mod.__define_delegation
      end

      def decorate
        __add_decorators
        __decorate_associations
        __delegate_decorated_association_methods

        self
      end

      private def __add_decorators
        decorators.each do |decorator|
          extend(decorator)
        end
      end

      private def __decorate_associations
        __associations.each do |assoc|
          public_send(assoc).try(:decorate)
        end
      end

      private def __delegate_decorated_association_methods
        __association_classes.each do |klass|
          methods = __decorator_methods(klass)

          self.class.delegate(
            *methods,
            to: klass.to_s.underscore,
            prefix: __prefix,
            allow_nil: __allow_nil)
        end
      end

      private def __decorator_methods(klass)
        klass.new.decorators.map(&:instance_methods).flatten
      end

      private def __association_classes
        __associations.map { |a| a.to_s.camelize.constantize }
      end
    end
  end
end
