require_relative "./composable_decorator/version"
require_relative './composable_decorator/class_methods'
require_relative './composable_decorator/instance_methods'

module ComposableDecorator
end

module ActiveRecord
  class Base
    extend ComposableDecorator::ClassMethods
    include ComposableDecorator::InstanceMethods
  end
end

