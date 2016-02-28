
class Api::V1::Recruiter::ApplicationController < ApplicationController
  before_action :authenticate_recruiter!

  rescue_from ActiveRecord::RecordNotFound do | e |
    handle_api_exception ApiException.new(ApiException.record_not_found)
  end

  def authenticate_admin!
    unless current_recruiter.role? == "admin"
      render json: { errors: ["Authorized users only."] }, status: 401
    end
  end

  def admin?
  	self.role == Role.find_by(:name => "admin")
  end

  #def not_authorized
  # render json: {errors: ["you dont have permission to access this resource"]} , status: 401
  #end

end