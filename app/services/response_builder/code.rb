class ResponseBuilder::Code < ResponseBuilder::Base
  attr_accessor :code

  def initialize(resource, config={})
    super(resource, config)
    @code = 1000
    set_code
  end

  private

  def set_code
    @code = 1300 if resource_has_errors?
    @code = resource.code if is_api_exception?
    @code = ApiException.internal_server_error[:code] if is_other_exception?
  end
  
end