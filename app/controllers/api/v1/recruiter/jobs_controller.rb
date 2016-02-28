class Api::V1::Recruiter::JobsController < ApplicationController

before_action :authenticate_recruiter!
before_action :set_job , only: [:show , :update]

	def index
	   # show all jobs based on roles
	   # refer recruiter modal.
		jobs = current_recruiter.jobs_posted
		serializer_responder(
			jobs.paginate(:page => params[:page], :per_page => 5),
			each_serializer: JobsSerializer)
	end

	def show
		serializer_responder(
			@job,
			serializer: JobsSerializer)
	end

	def create
	    # job creation permitted to all ( admin and normal recruiter )
	    job = current_recruiter.jobs.new(job_params)
	    job.company = current_recruiter.company
		job.save
		serializer_responder(
    		job, 
	  		serializer: JobsSerializer)
	end

	def update
		@job.update(job_params)
		serializer_responder(
			@job.reload ,
			serializer: JobsSerializer)
	end

    private 

	def set_job
		@job = current_recruiter.jobs_posted.find(params[:id])
	end

	def job_params
		params.require(:job).permit(:title , :department , :location , :salary , :description , :experience)
	end

end
