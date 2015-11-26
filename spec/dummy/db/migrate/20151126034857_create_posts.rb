class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :author_id
      t.string :name
      t.time :published_at

      t.timestamps null: false
    end
  end
end
