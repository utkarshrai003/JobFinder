 class ResponseBuilder::Messages < ResponseBuilder::Base
  attr_accessor :messages

  def initialize(resource, config={})
    super(resource, config)
    @messages = { }
    set_messages
  end

  private

  def set_messages
    @messages = resource.errors.full_messages if resource_has_errors?
    @messages = resource.full_messages if is_api_exception?  
    @messages = ApiException.new(ApiException.internal_server_error).full_messages if is_other_exception?
  end
  
end