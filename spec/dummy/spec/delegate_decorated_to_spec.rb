require 'rails_helper'

describe '#delegate_decorated_to' do
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

  GivenDecorator do
    module StoreDecorator
      def decorator_method
        "Store decorator method!"
      end
    end
  end

  context 'given a simple belongs_to association' do
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

  context 'given a subclass' do
    let(:store) { Store.create(name: 'store name') }
    let(:stetson) { Stetson.create(color: 'tan', store: store, author: author) }

    GivenModels do
      class Store < ActiveRecord::Base
        decorate_with StoreDecorator
      end

      class Author < ActiveRecord::Base
        decorate_with AuthorDecorator
      end

      class Hat < ActiveRecord::Base
        belongs_to :author

        delegate_decorated_to :author
      end

      class Stetson < Hat
        belongs_to :store

        delegate_decorated_to :store
      end
    end

    it 'delegates child associations\'s decorated methods' do
      stetson.decorate

      expect(stetson.store_decorator_method).to eq('Store decorator method!')
    end

    it 'delegates parent associations\'s decorated methods' do
      stetson.decorate

      expect(stetson.author_decorator_method).to eq('Author decorator method!')
    end
  end
end
