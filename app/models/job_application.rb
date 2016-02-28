class JobApplication < ActiveRecord::Base
	belongs_to :job
	belongs_to :applicant
	
    belongs_to :company
    belongs_to :recruiter

    validates_uniqueness_of :job_id , scope: :applicant_id

    scope :not_responded , -> {where("job_applications.status = 'pending'")}
end
