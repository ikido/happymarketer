class Image < ActiveRecord::Base
  attr_accessible :url
  belongs_to :tumblr_blog
  validates :tumblr_blog_id, :url, presence: true
  mount_uploader :data, ImageUploader
  
  scope :posting_queue, where(:state => :new).order('created_at ASC')
  scope :not_denied, where('state != ?', 'denied')
  scope :nex_to_post, posting_queue.limit(6)
  
  state_machine :initial => :new do
    state :queued
    state :posted
    state :denied
    
    event :deny do
      transition [:new, :queued] => :denied
    end
    
    event :mark_as_posted do
      transition [:new, :queued] => :posted
    end
    
    after_transition any => :denied do |image, transition|
      image.remove_data!
    end
    
  end    
  
  class << self
    def upload_batch
      images = self.posting_queue
      uploader = VkUploader.new
      uploader.upload_images_to_wall(images)
      
      images.each do |image|
        image.mark_as_posted!
      end
    end
    
    def recreate_versions_for_queued
      self.posting_queue.each { |i| i.data.recreate_versions! }
    end
  end
  
  def upload_from_url
    return false if new_record?

    self.remote_data_url = self.url
    result = self.save
    
    return result
  end
  
  def has_duplicate_md5_sum?
    has_duplicate_md5_sum = true
    
    unless self.md5_sum.blank?
      duplicate_images = self.class
        .where('id != ?', self.id)
        .where('state != ?', :denied)
        .where(md5_sum: self.md5_sum)
      
      has_duplicate_md5_sum = (duplicate_images.count > 0)
    end
    
    return has_duplicate_md5_sum
  end    
  
  def set_md5_sum
    return nil if data.blank?
    self.md5_sum = Digest::MD5.file(data.current_path).hexdigest
  end
  
  def hex_to_dec(hex_as_string = '')
    hex_as_string.hex.to_s(10)
  end
  
  def set_dominant_color
    return nil if data.blank?    
    
    colors = Miro::DominantColors.new(data.current_path)
    color = colors.to_hex.first[1..-1]
    
    self.dominant_color = hex_to_dec(color)
  end  
  
  # This method will be untested until we will add feature
  # to have several users
  
  def autorize_app
    
    # TODO: test with another user,
    # because we already had granted access so last step
    # with clicking 'allow' after reviewing permissions is skipped
    
    scope = [:audio, :video, :photos, :friends, :pages, :wall, :groups, :stats, :ads, :offline]
    auth_url = VkontakteApi.authorization_url(type: :client, scope: scope)
    
    agent = Mechanize.new { |a|
      a.user_agent_alias = 'iPhone'
    }
    
    page = agent.get(auth_url)
    login_form = page.forms.first
    login_form.email = ENV['VK_USER_EMAIL']
    login_form.pass = ENV['VK_USER_PASS']
    
    page = agent.submit(login_form, login_form.buttons.first)
    
    fragments = URI.parse(page.uri.to_s).fragment
    parameters = fragments.to_s.split('&').map{|f| f.split('=')}
    parameters = Hash[*parameters.flatten].sybolize_keys
    access_token = parameters[:access_token]
  end
  

end
