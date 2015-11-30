module ComposableDecorator
  module Models
    def self.included(base)
      base.extend DSL

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
end