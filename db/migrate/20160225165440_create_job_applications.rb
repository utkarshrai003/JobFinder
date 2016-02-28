class CreateJobApplications < ActiveRecord::Migration
  def change
    create_table :job_applications do |t|
      t.integer :applicant_id
      t.integer :job_id
      t.integer :company_id
      t.string :status , :default => 'pending'  # can be accepted / rejected

      t.timestamps null: false
    end
  end
end
