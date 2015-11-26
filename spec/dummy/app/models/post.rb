class Post < ActiveRecord::Base
  include ComposableDecorator

  has_many :comments
  belongs_to :author

  decorate_with PostDecorator

  delegate_decorated_to :author
end
