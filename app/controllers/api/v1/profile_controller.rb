class Api::V1::ProfileController < ApplicationController

before_action :authenticate_applicant!

	def index
		serializer_responder(
			current_applicant , 
			each_serializer: ApplicantsSerializer)
	end

	def update
		current_applicant.update(update_params)
		serializer_responder(
			current_applicant.reload , 
			serializer: ApplicantsSerializer)
	end

	private

	def update_params
		params.require(:profile).permit(:name , :experience , :current_location)
	end
end