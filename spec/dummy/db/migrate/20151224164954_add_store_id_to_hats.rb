class AddStoreIdToHats < ActiveRecord::Migration
  def change
    add_column :hats, :store_id, :integer
  end
end
