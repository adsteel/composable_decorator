require 'rails_helper'

describe '#delegate_decorated_to options' do
  let(:author) { Author.create(first_name: 'First', last_name: 'Last') }
  let(:post) { Post.create(name: 'Example Post', author_id: author.id) }

  GivenDecorator do
    module AuthorDecorator
      def decorator_method
        "Author decorator method!"
      end
    end
  end

  GivenDecorator do
    module PostDecorator
      def decorator_method
        "Post decorator method!"
      end
    end
  end

  context 'given an option of no prefix' do
    GivenModel do
      class Author < ActiveRecord::Base
        decorate_with AuthorDecorator
      end
    end

    GivenModel do
      class Post < ActiveRecord::Base
        belongs_to :author

        delegate_decorated_to :author, prefix: false
      end
    end

    it 'delegates the associations\'s decorated methods without a prefix' do
      expect( post.decorate.decorator_method ).to eq('Author decorator method!')
    end
  end

  context 'given an option of allow_nil: false' do
    let(:post) { Post.create(name: 'Post with no author') }

    GivenModel do
      class Author < ActiveRecord::Base
        decorate_with AuthorDecorator
      end
    end

    GivenModel do
      class Post < ActiveRecord::Base
        belongs_to :author

        delegate_decorated_to :author, allow_nil: false
      end
    end

    it 'raises an error when called' do
      expect{ post.decorate.author_decorator_method }.to raise_error( Module::DelegationError )
    end
  end
end
