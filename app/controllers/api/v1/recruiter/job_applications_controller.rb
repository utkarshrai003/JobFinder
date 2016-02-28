class Api::V1::Recruiter::JobApplicationsController < Api::V1::Recruiter::ApplicationController

before_action :authenticate_recruiter!
before_action :set_application , only: [:show , :update]

	def index
		# show based on roles
		# refer recruiter modal.
		job_applications = current_recruiter.applications
		serializer_responder(
			job_applications.
			paginate(:page => params[:page], :per_page => 5),
			each_serializer: JobApplicationsSerializer)
	end

	def show
		# check and show based on roles
		serializer_responder(
			@application , 
			serializer: JobApplicationsSerializer)
	end

	def update
		@application.update(:status => params[:status])
		serializer_responder(
			@application.reload,
		    serializer: JobApplicationsSerializer)
	end

	private

	def update_params
		params.permit(:status)
	end

	def set_application
		@application = current_recruiter.applications.find(params[:id])
	end

end