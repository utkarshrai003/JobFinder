class Api::V1::JobsController < ApplicationController
	
before_action :set_job , only: [:show]
before_action :authenticate_applicant!

	def index
		if params[:search]
			jobs = Jobs::Search.new.search(params[:search])
		elsif params[:job]
			if has?(:title , :location , :experience)
				jobs = Jobs::Search.new.with_title_loc_exp(params[:job][:title] , params[:job][:location] , params[:job][:experience])
			elsif has?(:title , :location)
				jobs = Jobs::Search.new.with_title_loc_exp(params[:job][:title] , params[:job][:location])
			elsif has?(:title)
				jobs = Jobs::Search.new.with_title(params[:job][:title])
			end
		else
			jobs = Job.all
		end

		serializer_responder(
			jobs , 
			each_serailizer: JobsSerializer)
	end

	def show
		serializer_responder(
			@job ,
			serailizer: JobsSerializer)
	end

	private

	def set_job
		@job = Job.find(params[:id])
	end

	def has?(*keys)
		keys.all? {|k| params[:job].has_key? k}
	end

end
