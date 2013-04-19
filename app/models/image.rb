class Image < ActiveRecord::Base
  attr_accessible :url
  belongs_to :tumblr_blog
  validates :tumblr_blog_id, :url, presence: true
  mount_uploader :data, ImageUploader
  
  def upload_from_url
    return false if new_record?

    self.remote_data_url = self.url
    result = self.save
    
    return result
  end
end
