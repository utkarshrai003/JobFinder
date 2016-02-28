class JobApplicationsSerializer < ActiveModel::Serializer

	 attributes :id,
	 			:status , 
	 			:company ,
	 			:job , 
	 			:applicant 			 

end
