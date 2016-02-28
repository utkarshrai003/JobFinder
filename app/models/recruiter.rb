class Recruiter < ActiveRecord::Base

	include DeviseTokenAuth::Concerns::User

	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

	belongs_to :role 
	belongs_to :company
	has_many :jobs
	has_many :job_applications, through: :jobs

	delegate :company_departments, to: :company
	

	def applications
		admin ? self.company.job_applications : self.job_applications
	end

	def jobs_posted
		admin ? self.company.jobs : self.jobs
	end

	def admin
		true if self.role.name == "admin"
	end

	def role?
		self.role.name
	end


  
end

