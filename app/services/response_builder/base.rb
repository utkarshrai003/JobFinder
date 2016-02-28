class ResponseBuilder::Base
  attr_accessor :resource,
                :config
                
  def initialize(resource, config={})
    @resource = resource
    @config = config
  end

  protected

  def is_active_model_object?
    @resource.kind_of?(ActiveRecord::Base) 
  end

  def is_hash_object?
    @resource.kind_of?(Hash)
  end

  def resource_has_errors?
    is_active_model_object? and !@resource.valid?
  end

  def is_collection?
    @resource.kind_of?(ActiveRecord::Relation) || @resource.kind_of?(Array)
  end

  def is_other_exception?
    !is_api_exception? and @resource.kind_of?(StandardError)
  end

  def is_api_exception?
    @resource.kind_of?(ApiException)
  end

end