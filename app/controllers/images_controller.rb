# simple class with helpers, to keep controller code DRY

class ImagesController < ApplicationController
  
  def index
    @images = Image.posting_queue.all
  end
  
  def deny
    @image = Image.find(params[:id])
    @image.deny!
    redirect_to images_path, notice: 'Image has been denied'
  end
  
end