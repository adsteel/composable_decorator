require 'rails_helper'

describe '#decorate' do
  let(:author) { Author.create(first_name: 'First', last_name: 'Last') }
  let(:post) { Post.create(name: 'Example Post', author_id: author.id) }
  let(:comment) { Comment.create(content: 'Comment Content', post_id: post) }

  it 'decorates the model' do
    expect{ author.decorator_method }.to raise_error( NoMethodError )

    author.decorate

    expect{ author.decorator_method }.not_to raise_error
  end

  it 'decorates the associations' do
    comment && author.decorate

    expect{ author.posts.first.decorator_method }.not_to raise_error
    expect{ author.comments.first.decorator_method }.not_to raise_error
  end

  it 'delegates the associations\'s decorated methods' do
    expect{ post.decorate.author_decorator_method }.not_to raise_error
    expect{ comment.decorate.post_decorator_method }.not_to raise_error
  end
end