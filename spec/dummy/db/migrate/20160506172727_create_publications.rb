class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :name
    end
  end
end
