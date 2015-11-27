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
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.extend SpecDSL
end
