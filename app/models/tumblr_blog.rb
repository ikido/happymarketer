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
  
private

  def add_image_if_needed(image_url)
    unless self.images.exists?(url: image_url)
      image = self.images.create(url: image_url)        
      image.upload_from_url
    end
  end

  def images_from_rss
    require 'rss'

    images = []    
    rss = RSS::Parser.parse(rss_url)
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
