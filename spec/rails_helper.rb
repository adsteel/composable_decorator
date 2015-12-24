ENV['RAILS_ENV'] ||= 'test'

require 'dummy/config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'pry'

module SpecDSL
  def GivenModel
    let!(:_saved_constant_names) { Object.constants }

    before do
      yield
    end

    after do
      new_constants = Object.constants - _saved_constant_names

      new_constants.
        select { |e| Object.const_get(e) }.
        each { |e| Object.send :remove_const, e }
    end
  end

  alias_method :GivenDecorator, :GivenModel
end

RSpec.configure do |config|
  config.extend SpecDSL
end

ActiveRecord::Migration.maintain_test_schema!
