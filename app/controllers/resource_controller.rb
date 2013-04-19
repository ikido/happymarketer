# simple class with helpers, to keep controller code DRY

class ResourceController < ApplicationController
  
  def load_collection
    unless instance_variable_get("@#{resource_name.pluralize}")
      instance_variable_set("@#{resource_name.pluralize}", resource_class.all)
    end
  end

  def collection
    instance_variable_get("@#{resource_name.pluralize}")
  end

  def collection_path
    send("#{resource_name.pluralize}_path")
  end

  def build_resource(new_resource_attributes = {})
    unless instance_variable_get("@#{resource_name}")
      instance_variable_set("@#{resource_name}", resource_class.new(new_resource_attributes))
    end
  
    return instance_variable_get("@#{resource_name}")
  end

  def load_resource
    unless instance_variable_get("@#{resource_name}")
      instance_variable_set("@#{resource_name}", resource_class.find(params[:id]))
    end
  
    return instance_variable_get("@#{resource_name}")
  end

  def resource
    instance_variable_get("@#{resource_name}")
  end

  def resource_name
    params[:controller].singularize
  end

  def resource_class
    resource_name.classify.constantize
  end

  def resource_attributes
    return params[resource_name.to_sym]
  end
  
end