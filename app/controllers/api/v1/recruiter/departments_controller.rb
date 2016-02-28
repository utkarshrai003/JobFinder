class Api::V1::Recruiter::DepartmentsController < Api::V1::Recruiter::ApplicationController

before_action :authenticate_recruiter!
before_action :authenticate_admin! , only: [:create , :update]
before_action :set_department , only: [:show , :update]


	def index
		departments = current_recruiter.company.departments
		serializer_responder(
			departments ,
			each_serializer: DepartmentsSerializer)
	end

	def show
		serializer_responder(
			@department , 
			serializer: DepartmentsSerializer)
	end

	def create
		# only admin
		department = current_recruiter.company.departments.create(department_params)
		serializer_responder(
			department , 
			serializer: DepartmentsSerializer)
	end

	def update
		# only admin
		@department.update(department_params)
		serializer_responder(
			@department.reload , 
			serializer: DepartmentsSerializer)
	end

	private

	def set_department
		@department = current_recruiter.company_departments.find(params[:id])
	end

	def department_params
		params.require('department').permit(:name)
	end 

end


