require_relative "./composable_decorator/version"
require_relative './composable_decorator/class_methods'
require_relative './composable_decorator/instance_methods'

module ComposableDecorator
  def self.included(mod)
    mod.extend ClassMethods
    mod.include InstanceMethods
  end
end

module ActiveRecord
  class Base
    include ComposableDecorator
  end
end

