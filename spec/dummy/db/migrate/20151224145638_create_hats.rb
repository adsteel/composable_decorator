class CreateHats < ActiveRecord::Migration
  def change
    create_table :hats do |t|
      t.string :type
      t.string :color

      t.timestamps null: false
    end
  end
end
