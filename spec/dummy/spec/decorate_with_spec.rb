require 'rails_helper'

describe '#decorate_with' do
  let(:author) { Author.create(first_name: 'First', last_name: 'Last') }

  context 'decorating a single model' do
    GivenDecorator do
      module AuthorDecorator
        def decorator_method
          "This is a decorator method!"
        end
      end
    end

    GivenModel do
      class Author < ActiveRecord::Base
        include ComposableDecorator

        decorate_with AuthorDecorator
      end
    end

    it 'adds the decorated methods' do
      expect{ author.decorator_method }.to raise_error( NoMethodError )

      author.decorate

      expect{ author.decorator_method }.not_to raise_error
    end
  end
end