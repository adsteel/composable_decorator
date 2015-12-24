require 'rails_helper'

describe '#delegate_decorated_to' do
  let(:author) { Author.create(first_name: 'First', last_name: 'Last') }
  let(:post) { Post.create(name: 'Example Post', author_id: author.id) }

  context 'given a simple belongs_to association' do
    GivenDecorator do
      module AuthorDecorator
        def decorator_method
          "This is a decorator method!"
        end
      end
    end

    GivenDecorator do
      module PostDecorator
        def decorator_method
          "This is a decorator method"
        end
      end
    end

    GivenModel do
      class Author < ActiveRecord::Base
        decorate_with AuthorDecorator
      end
    end

    GivenModel do
      class Post < ActiveRecord::Base
        belongs_to :author

        delegate_decorated_to :author
      end
    end

    it 'delegates the associations\'s decorated methods' do
      expect{ post.decorate.author_decorator_method }.not_to raise_error
    end
  end

  context 'given a custom belongs_to association' do
    GivenDecorator do
      module AuthorDecorator
        def decorator_method
          "This is a decorator method!"
        end
      end
    end

    GivenDecorator do
      module PostDecorator
        def decorator_method
          "This is a decorator method"
        end
      end
    end

    GivenModel do
      class Author < ActiveRecord::Base
        decorate_with AuthorDecorator
      end
    end

    GivenModel do
      class Post < ActiveRecord::Base
        belongs_to :my_author, class_name: 'Author', foreign_key: :author_id

        decorate_with PostDecorator

        delegate_decorated_to :my_author
      end
    end

    it 'delegates the associations\'s decorated methods' do
      expect{ post.decorate.my_author_decorator_method }.not_to raise_error
    end

    context 'and a nil association record' do
      let(:post) { Post.create(name: 'Post with no author') }

      it 'returns nil for the delegated method' do
        expect(post.decorate.my_author_decorator_method).to eq(nil)
      end
    end
  end
end
