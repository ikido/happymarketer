require 'spec_helper'

describe TumblrBlog do
  
  it { should have_many(:images) }
  
  it { should allow_mass_assignment_of(:name) }
  it { should_not allow_mass_assignment_of(:images_updated_at) }
  
  it "has a valid factory" do
    FactoryGirl.build(:tumblr_blog).should be_valid
  end
  
  it { should allow_value('so_mE-name1').for(:name) }
  it { should_not allow_value('').for(:name) }
  it { should_not allow_value('some name').for(:name) }
  it { should_not allow_value('!somename').for(:name) }
  it { should_not allow_value('some.name').for(:name) }
  it { should_not allow_value('-_-').for(:name) }
  it { should_not allow_value('123').for(:name) }

  
  describe "rss_url" do
    
    it "is private"
    
    it "returns rss url from name"
  
  end
  
  describe "images_from_rss" do
    let(:tumblr_blog) { FactoryGirl.create(:tumblr_blog, name: 'jussk8') }
    
    it "return empty array if rss is not accessible"
    
    it "return empty array if rss is not valid"
    
    it "return empty array if no images found"
    
    it "is private"
    
    it "should set errors when images could not be retrieved"
    
    it "uses RSS::Parser" do
      
      require 'rss'
      
      rss = mock(Object)
      rss.stub(:items).and_return([])
      
      RSS::Parser.should_receive(:parse)
        .with(tumblr_blog.send(:rss_url))
        .and_return(rss)
        
      tumblr_blog.send(:images_from_rss)
    end
    
    it "loads images from blogs rss", :vcr do      
      first_image = "http://24.media.tumblr.com/132c57c65b88d54448a948cc85f21586/tumblr_mj3wtdqs6R1qhy5n3o1_500.jpg"
      images = tumblr_blog.send(:images_from_rss)
      images.class.name.should == 'Array'
      images.count.should == 14
      images.first.should == first_image
    end
    
  end
  
  describe "image_extension_valid?" do
    
    it "is private"
    
    let(:tumblr_blog) { FactoryGirl.build(:tumblr_blog) }
    
    it "returns true for valid image extension" do
      valid_extensions = %w(.jpg .jpeg .png)
      image_url = "http://24.media.tumblr.com/132c57c65b"
      valid_extensions.each do |ext|
        tumblr_blog.send(:image_extension_valid?, image_url+ext).should be_true
      end
    end
    
    it "returns false for invalid image extension" do      
      image_url = "http://24.media.tumblr.com/132c57c65b.gif"
      tumblr_blog.send(:image_extension_valid?, image_url).should be_false
    end
    
  end
  
  describe "image_srcs_from_string" do
    
    it "is private"
    
    let(:tumblr_blog) { FactoryGirl.build(:tumblr_blog) }
    
    let(:str) do 
      '<img src="http://24.media.tumblr.com/6/tumblr.jpg" />
      <blockquote> <p>Jr Vitale - Nollie Flip</p> </blockquote>
      <img src="http://24.media.tumblr.com/6/tumblr2.jpg" />' 
    end
    
    it "returns array of image urls from html string" do
      result_array = [
        'http://24.media.tumblr.com/6/tumblr.jpg',
        'http://24.media.tumblr.com/6/tumblr2.jpg'
      ]
      
      tumblr_blog.send(:image_srcs_from_string, str).should eq(result_array)
    end
  
    it "filters out gif images" do
      new_str = str+'some txt <img src="http://24.com/6/tumblr2.gif" />'
      
      result_array = [
        'http://24.media.tumblr.com/6/tumblr.jpg',
        'http://24.media.tumblr.com/6/tumblr2.jpg'
      ]
      
      tumblr_blog.send(:image_srcs_from_string, new_str).should eq(result_array)
    end
    
  end
  
  describe "update_images" do

    let(:tumblr_blog) { FactoryGirl.build(:tumblr_blog) }
    
    before(:each) do
      tumblr_blog.stub(:images_from_rss).and_return([])
    end

    it "loads images" do
      tumblr_blog.should_receive(:images_from_rss)
      tumblr_blog.update_images
    end
    
    it "runs add_image_if_needed for each image" do
      images = [
        'http://24.media.tumblr.com/6/tumblr.jpg',
        'http://24.media.tumblr.com/6/tumblr2.jpg'
      ]
      
      tumblr_blog.stub(:images_from_rss).and_return(images)
      images.each do |i|
        tumblr_blog.should_receive(:add_image_if_needed).with(i)
      end
      
      tumblr_blog.update_images
    end
    
    it "sets images_updated_at" do
      current_time = Time.now
      
      Timecop.freeze(current_time) do
        tumblr_blog.update_images
      end
      
      tumblr_blog.images_updated_at.should == current_time
    end
  
  end   
    
  describe "add_image_if_needed" do
    
    let(:tumblr_blog) { FactoryGirl.build(:tumblr_blog) }
    let(:image_url) { 'http://24.media.tumblr.com/6/tumblr.jpg' }
    let(:images_relation) { mock(Object) }
    let(:image) { FactoryGirl.build_stubbed(:image) }
    
    before(:each) do
      tumblr_blog.stub(:images).and_return(images_relation)
      image.stub(:upload_from_url)
    end
    
    it "is private"
    
    context "when image already exists (by url)" do
      
      before(:each) do
        images_relation.stub(:exists?).and_return(true)
      end
    
      it "does not create new image" do
        images_relation.should_not_receive(:create).with(url: image_url)
        tumblr_blog.send(:add_image_if_needed, image_url)
      end
      
    end
    
    context "when new image" do
    
      before(:each) do
        images_relation.stub(:exists?).and_return(false)
        images_relation.stub(:create).and_return(image)
      end
    
      it "creates new images" do
        images_relation.should_receive(:create).with(url: image_url)
        tumblr_blog.send(:add_image_if_needed, image_url)
      end
      
      it "uploads them from url" do
        image.should_receive(:upload_from_url)
        tumblr_blog.send(:add_image_if_needed, image_url)
      end
    end
    
  end
    
end
