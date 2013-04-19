class TumblrBlogsController < ResourceController
  
  def index
    load_collection
  end
  
  def new
    build_resource
  end
  
  def create
    build_resource(resource_attributes)

    if resource.save
      redirect_to collection_path, notice: 'Tumblr Blog successfully created'
    else
      render action: "new"
    end
  end
  
  def edit
    load_resource
  end
  
  def update
    load_resource

    if resource.update_attributes(resource_attributes)
      redirect_to collection_path, notice: 'Tumblr Blog successfully updated'
    else
      render action: "edit"
    end
  end
  
  def destroy
    load_resource
    
    if resource.destroy
      redirect_options = { notice: 'Tumblr Blog successfully deleted' }
    else
      redirect_options = { alert: "Error. Cannot delete Tumbl Blog: #{resource.errors.inspect}" }
    end
    
    redirect_to collection_path, redirect_options
  end
  
end
