class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  protect_from_forgery with: :null_session

    rescue_from ActiveRecord::RecordNotFound do | e |
    handle_api_exception ApiException.new(ApiException.record_not_found)
  end

  rescue_from ::ApiException do | e |
    handle_api_exception(e)
  end

  def default_serializer_options
    {root: false}
  end

  def serializer_responder(resource, config={})
    render json: ResponseBuilder::Main.new(resource, config, params).response
  end

  def handle_api_exception(e)
    render json: ResponseBuilder::Main.new(e, { }, params).response
  end

  def not_authorized
    render json: {errors: ["you dont have permission to access this resource"]} , status: 401
  end
  
end
