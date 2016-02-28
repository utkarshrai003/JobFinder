class ResponseBuilder::Data < ResponseBuilder::Base
  attr_accessor :data

  def initialize(resource, config={})
    super(resource, config)
    config.merge!({root: false})
    @data = nil
    set_data
  end

  private

  def set_data
    set_object_data
    set_collection_data
  end

  def set_collection_data
    return if !is_collection?
    @data = JSON.parse(ActiveModel::ArraySerializer.new(resource, config).to_json(root: false))
  end

  def set_object_data
    return if(!is_active_model_object? && !is_hash_object?)
    r = config[:serializer] ? config[:serializer].new(resource, config) : resource 
    @data = JSON.parse(r.to_json(root: false))
  end
end