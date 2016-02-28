class Applicant < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable

  include DeviseTokenAuth::Concerns::User

   has_many :jobs , through: :job_applications
   has_many :job_applications

   def apply_for(job)
   	  # status = 0 # pending application
   		self.job_applications.new(:job_id => job.id , :company_id => job.company.id)
   end

end
