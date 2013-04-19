require 'spec_helper'

describe Image do
  it "should have valid factory" do
    FactoryGirl.build(:image).should be_valid
  end
  
  it { should belong_to(:tumblr_blog) }
  
  it { should validate_presence_of(:tumblr_blog_id) }
  it { should validate_presence_of(:url) }
  
  it { should allow_mass_assignment_of(:url) }
  it { should_not allow_mass_assignment_of(:tumblr_blog_id) }
  it { should_not allow_mass_assignment_of(:data) }
  it { should_not allow_mass_assignment_of(:remote_data_url) }

  describe "upload_from_url" do
    
    context "when model is not yet saved (new_record)" do
      
      let(:image) { FactoryGirl.build(:image) }
      
      it "should add error to model error messages"
        
      it "should return false" do
        image.upload_from_url.should be_false
      end
        
      it "should not upload" do
        image.should_not_receive(:save)
        image.data.should be_blank
      end
      
    end  
    
    context "when model is already saved" do
      
      let(:image) do 
        FactoryGirl.create(:image,
          url: 'http://24.media.tumblr.com/132c57c65b88d54448a948cc85f21586/tumblr_mj3wtdqs6R1qhy5n3o1_500.jpg'
        )
      end
      
      before(:each) do
        image.remote_data_url = image.url
      end
      
      context "when download successfull" do
        
        it "should save image" do
          image.should_receive(:save)
          image.upload_from_url
        end
        
        it "should download and store image"
        
        it "should assign data to new image url", :vcr do
          image.upload_from_url
          image.data.should_not be_blank
        end
        
        it "should return true", :vcr do
          image.upload_from_url.should be_true
        end
      end
      
      context "when download fails" do
        
        it "should return false" do
          image.upload_from_url.should be_false
        end
          
        it "shoudl add errors to model" do
          image.upload_from_url
          image.errors.messages[:data].should include('could not download file')
        end
        
      end
      
    end
  end
  
  it "should calculate dominant colors from images"
  
  it "sould have named scope to sort images by color"
end
