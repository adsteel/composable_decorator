require 'composable_decorator/version'
require 'composable_decorator/active_record/base'
require 'composable_decorator/dsl'
require 'active_record'

ActiveRecord::Base.include ComposableDecorator::ActiveRecord::Base

module ComposableDecorator
  def self.included(mod)
    mod.extend DSL
  end
end
