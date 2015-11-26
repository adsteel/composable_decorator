class Author < ActiveRecord::Base
  include ComposableDecorator

  has_many :posts

  decorate_with AuthorDecorator
end
