class Api::V1::JobApplicationsController < ApplicationController
	
	before_action :authenticate_applicant!
	before_action :set_job , only: [:create]
	before_action :set_job_application , only: [:show]

	def index
		# all job applications belonging to the logged in applicant
		job_applications = current_applicant.job_applications
		serializer_responder(
			job_applications , 
			each_serializer: JobApplicationsSerializer)
	end

	def create
		# given a job , apply for it
		job_application = current_applicant.job_applications.new
		job_application.job = @job
		job_application.company = @job.company
		job_application.save
		serializer_responder(
			job_application , 
			serializer: JobApplicationsSerializer)
	end

	def show
		# show if the job app belongs to the current applicant
		serializer_responder(
			@job_application , 
			serializer: JobApplicationsSerializer)
	end

	private

	def set_job
		@job = Job.find(params[:id])
	end

	def set_job_application
		@job_application = JobApplication.find(params[:id])
		not_authorized unless current_applicant.job_applications.include?(@job_application)
	end

end