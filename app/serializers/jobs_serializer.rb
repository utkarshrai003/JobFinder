class JobsSerializer < ActiveModel::Serializer
  
  attributes :id , 
  			 :title,
  			 :department,
  			 :location,
  			 :salary,
  			 :description,
  			 :experience,
  			 :status,
  			 :company_id,
  			 :recruiter_id 	

  has_many :job_applications		 
end
