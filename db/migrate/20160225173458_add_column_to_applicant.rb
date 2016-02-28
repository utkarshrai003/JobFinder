class AddColumnToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :current_location, :string
    add_column :applicants, :experience, :integer
  end
end
