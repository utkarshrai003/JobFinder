class Api::V1::Recruiter::ProfileController < ApplicationController
	
	before_action :authenticate_recruiter!

	def index
		serializer_responder(
			current_recruiter , 
			each_serializer: RecruitersSerializer)
	end

	def update
		# his name and if admin company name also
		current_recruiter.update(:name => params[:profile][:name]) if params[:profile][:name].present?
		current_recruiter.company.update(:name => params[:profile][:company]) if params[:profile][:company].present?
		serializer_responder(
			current_recruiter.reload ,
		 	serializer: RecruitersSerializer)
	end

	private

	def update_params
		admin? ? params.require(:profile).permit(:name , :company) : params.require(:profile).permit(:name)
	end
end

