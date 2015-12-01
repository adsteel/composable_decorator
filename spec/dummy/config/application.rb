require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'composable_decorator'

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.helper = false
      g.assets = false
      g.template_engine :slim
      g.test_framework nil
    end
  end
end
