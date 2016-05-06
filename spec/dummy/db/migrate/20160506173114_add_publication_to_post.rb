class AddPublicationToPost < ActiveRecord::Migration
  def change
    add_column :posts, :publication_id, :integer
  end
end
