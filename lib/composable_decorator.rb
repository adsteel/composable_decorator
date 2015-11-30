require_relative './composable_decorator/version'
require_relative './composable_decorator/active_record/base'

ActiveRecord::Base.include ComposableDecorator::ActiveRecord::Base
