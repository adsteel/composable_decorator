require_relative "./composable_decorator/version"
require_relative './composable_decorator/dsl'
require_relative './composable_decorator/models'

module ComposableDecorator
end

module ActiveRecord
  class Base
    extend ComposableDecorator::DSL
    include ComposableDecorator::Models
  end
end

