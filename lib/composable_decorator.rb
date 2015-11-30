require_relative './composable_decorator/version'
require_relative './composable_decorator/active_record/base'

module ActiveRecord
  class Base
    include ComposableDecorator::ActiveRecord::Base
  end
end
