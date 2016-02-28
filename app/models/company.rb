class Company < ActiveRecord::Base
	has_many :recruiters
	has_many :departments
	has_many :jobs
	has_many :job_applications

	def company_departments
		self.departments
	end
end
