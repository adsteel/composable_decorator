class AddCompanyToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :company_id, :integer
  end
end
