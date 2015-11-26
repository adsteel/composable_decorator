class Comment < ActiveRecord::Base
  include ComposableDecorator

  belongs_to :post

  decorate_with CommentDecorator

  delegate_decorated_to :post
end
