require 'composable_decorator/version'
require 'composable_decorator/active_record/base'
require 'active_record'

ActiveRecord::Base.include ComposableDecorator::ActiveRecord::Base
