class AddColumnsToRecruiter < ActiveRecord::Migration
  def change
    add_column :recruiters, :company_id, :integer
    add_column :recruiters, :role_id, :integer
  end
end
