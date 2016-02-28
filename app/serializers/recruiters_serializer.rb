class RecruitersSerializer < ActiveModel::Serializer
	
  attributes :id,
  			 :email,
  			 :name,
  			 :role_id,
  			 :company		 
end
