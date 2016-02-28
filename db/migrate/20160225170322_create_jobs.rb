class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :department
      t.string :location
      t.integer :salary
      t.string :description
      t.integer :experience
      t.string :status , :default => "active"  # can be 'inactive'
      t.integer :company_id
      t.integer :recruiter_id

      t.timestamps null: false
    end
  end
end
