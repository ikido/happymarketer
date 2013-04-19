class VkUploader
  
  def initialize
    @agent = VkontakteApi::Client.new(ENV['VK_APP_TOKEN'])
    
    @config = Hashie::Mash.new({
      owner_id_type: :gid,  # or :uid
      owner_id: ENV['VK_GROUP_ID'], #  ENV['VK_USER_ID']
      album_name: ENV['VK_ALBUM_NAME'],
      from_group: 1
    })
  end  
  
  
  
  def upload_images_to_wall(images)
    images.reject!{ |i| i.data.blank? } # remove images without data
    album_id = get_or_create_album(@config.album_name)
    
    # upload images 
    vk_image_ids = []
    images.each_slice(5) do |current_batch|      
      current_ids = batch_upload(current_batch, album_id)
      vk_image_ids = vk_image_ids + current_ids
    end
    
    attachments = vk_image_ids.map { |i| "photo-#{@config.owner_id}_#{i}" }

    @agent.wall.post(
      owner_id: "-#{@config.owner_id}",
      attachments: attachments.join(','),
      from_group: @config.from_group
    )
  end
  
  
  
  
  # we upload only 5 images as vk supports
  def batch_upload(images, album_id)
    upload_url = get_upload_url(album_id)    
    vk_options = { url: upload_url }
          
    images.slice(0, 5).each_with_index do |image, i|
      vk_options["file#{i+1}"] = get_image_metadata(image)
    end
    
    puts vk_options.inspect
    upload_response = VkontakteApi.upload(vk_options)
    save_response = @agent.photos.save(upload_response)
    
    return save_response.map{ |i| i.pid }
  end
  
  
  
  
  
  def get_or_create_album(album_name)
    
    # get album id for category, or create new
    albums = @agent.photos.get_albums(
      :gid => @config.owner_id
    )
    
    existing_album = albums.find {|a| a.title == album_name }

    unless existing_album
      puts "album not found, creating new one"
      
      response = @agent.photos.create_album(
        :title => album_name,
        @config.owner_id_type => @config.owner_id
      )
      
      album_id = response.aid
    else
      album_id = existing_album.aid
    end
    
    return album_id
  end
  
  
  
  def get_upload_url(album_id)
    
    response = @agent.photos.get_upload_server(
      :aid => album_id,
      @config.owner_id_type => @config.owner_id
    )
    
    return response.upload_url
  end
  
  
  
  
  def get_image_metadata(image)
    file_path = Rails.root.join('public').to_s+image.data.url(:to_post)
    mime_type = MIME::Types.type_for(file_path).first.content_type
    return [file_path, mime_type]
  end
  

end