require 'rails_helper'

describe '#decorate_with' do
  let(:author) { Author.create(first_name: 'First', last_name: 'Last') }
  let(:stetson) { Stetson.create(color: 'tan') }

  context 'given a model with a single decorator' do
    GivenDecorator do
      module AuthorDecorator
        def decorator_method
          "This is a decorator method!"
        end
      end
    end

    GivenModel do
      class Author < ActiveRecord::Base
        decorate_with AuthorDecorator
      end
    end

    it 'adds the decorator\'s methods' do
      expect{ author.decorator_method }.to raise_error( NoMethodError )

      author.decorate

      expect{ author.decorator_method }.not_to raise_error
    end
  end

  context 'given a subclass' do
    GivenDecorator do
      module HatDecorator
        def hat_decorator_method
          "Hat decorator method!"
        end
      end
    end

    GivenDecorator do
      module StetsonDecorator
        def stetson_decorator_method
          "Stetson decorator method!"
        end
      end
    end

    GivenModel do
      class Hat < ActiveRecord::Base
        decorate_with HatDecorator
      end
    end

    GivenModel do
      class Stetson < Hat
        decorate_with StetsonDecorator
      end
    end

    it 'adds the child\'s decorators' do
      stetson.decorate

      expect( stetson.stetson_decorator_method ).to eq( "Stetson decorator method!" )
    end

    it 'adds the parent\'s decorators' do
      stetson.decorate

      expect( stetson.hat_decorator_method ).to eq( "Hat decorator method!" )
    end
  end
end
