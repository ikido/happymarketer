class TumblrBlog < ActiveRecord::Base
  
  attr_accessible :name
  
  validates :name,
    :presence => true,
    :format => { :with => /\A(?=.*[a-z])[a-z\-_\d]+\Z/i }
    
  has_many :images
  
  def update_images
    images_from_rss.each do |image_url|
      add_image_if_needed(image_url)
    end
    
    self.images_updated_at = Time.now
    save
  end
  
  class << self
    def update_all_images
      self.where('images_updated_at < ? OR images_updated_at IS NULL', 6.hours.ago).each do |tb|
        puts "updating #{tb.name}"
        tb.update_images
        puts "done"
        sleep(10)
      end
    end
    
    def reprocess_all_images
      self.all.each do |tb|
        puts "reprocessing #{tb.name}"
        tb.reprocess_images
        puts "done"
      end
    end
    
    def publish_batch
    end
  end
  
  def reprocess_images
    self.images.each { |i| i.data.recreate_versions! }
  end
  
private

  # TODO: now we simply deny images which are redirecting
  
  def add_image_if_needed(image_url)
    unless self.images.exists?(url: image_url)
      image = self.images.create(url: image_url)        
      
      begin
        image.upload_from_url
      rescue
        image.deny!
      end
      
      image.set_md5_sum
      
      if image.has_duplicate_md5_sum?
        image.deny!
      else              
        image.set_dominant_color      
      end
      
      image.save
    end
  end

  # TODO: we ignore rss feeds that are redirecting for now

  def images_from_rss
    require 'rss'

    images = []
    
    begin  
      rss = RSS::Parser.parse(rss_url)
    rescue
      return []
    end
    
    rss.items.each do |item|
      image_srcs_from_string(item.description).each { |i| images << i }
    end

    return images
  end

  def rss_url
    return "http://#{name}.tumblr.com/rss"
  end
  
  def image_srcs_from_string(string)
    doc = Nokogiri::HTML( string )
    img_srcs = doc.css('img').map{ |i| i['src']  }
    return img_srcs.select { |i| image_extension_valid?(i) }
  end
  
  def image_extension_valid?(image_url)
    valid_extensions = %w(.jpg .jpeg .png)
    ext = File.extname(image_url)
    return (valid_extensions.include?(ext) ? true : false)
  end
  
end
