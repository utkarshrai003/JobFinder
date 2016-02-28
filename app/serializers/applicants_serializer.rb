class ApplicantsSerializer < ActiveModel::Serializer
	
  attributes :id,
  			 :email,
  			 :name,
  			 :experience,
  			 :current_location		 
end