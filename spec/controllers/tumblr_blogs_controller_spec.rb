require 'spec_helper'

describe TumblrBlogsController do
  
  let(:resource_name) { 'tumblr_blog' }
  let(:collection_name) { resource_name.pluralize }
  
  let(:resource_class) { resource_name.classify.constantize }
  let(:resource_attributes) do 
    FactoryGirl.attributes_for(resource_name).stringify_keys
  end
  
  let(:resource) { FactoryGirl.build_stubbed(resource_name) }
  let(:collection) { [resource] }
  
  let(:collection_path) { send("#{collection_name}_path") }
  
  
  describe "GET #index" do
     before(:each) do
       resource_class.stub(:all).and_return(collection)
     end
     
     it "locates list of resources" do
       resource_class.should_receive(:all)
       get :index
       assigns(collection_name).should eq(collection)
     end
     
     it "renders the :index view" do
       get :index
       response.should render_template :index
     end
   end
  
  describe "GET #new" do
    before(:each) do
      @current_resource = FactoryGirl.build(resource_name)      
      resource_class.stub(:new).and_return(@current_resource)                   
    end
    
    it "builds resource" do
      resource_class.should_receive(:new)
      get :new       
      assigns(resource_name).should eq(@current_resource)
    end
    
    it "renders new template" do
      get :new
      response.should render_template :new
    end
    
  end
  
  describe "POST #create" do
  
    before(:each) do
      @current_resource = resource
      resource_class.stub(:new).and_return(@current_resource)
      @current_resource.stub(:save)
    end
    
    it "builds new resource with given attributes" do
      resource_class.should_receive(:new).with(resource_attributes)
      post :create, resource_name => resource_attributes
    end
    
    it "saves new resource " do
      @current_resource.should_receive(:save)
      post :create
    end
    
    context "with valid attributes" do
       
      before(:each) do
        @current_resource.stub(:save).and_return(true)
      end      
  
      it "redirects to index action" do
        post :create
        response.should redirect_to collection_path
      end
  
      it "sets flash message" do
        post :create
        flash[:notice].should_not be_empty
      end
  
    end
  
     context "with invalid attributes" do
       
       before(:each) do
         @current_resource.stub(:save).and_return(false)
       end      
  
       it "re-renders new template" do
         post :create
         response.should render_template :new
       end
       
     end
     
   end
     
   describe "GET #edit" do
       
     before(:each) do
       @current_resource = resource
       resource_class.stub(:find).and_return(@current_resource)
     end
  
     it "locates resource " do
       resource_class.should_receive(:find).with("1")
       get :edit, id: "1"
       assigns(resource_name).should eq(@current_resource)
     end
       
     it "renders edit template" do
       get :edit, id: resource.id
       response.should render_template :edit
     end
  
   end
   
   describe "PUT #update" do
        
    before(:each) do
      @current_resource = resource    
      resource_class.stub(:find).and_return(@current_resource)
      @current_resource.stub(:update_attributes)     
    end
    
    it "locates requested resource" do
      resource_class.should_receive(:find).with("1")
      put :update, id: "1"
    end
    
    it "updates resource attributes" do
      @current_resource.should_receive(:update_attributes).with(resource_attributes)
      put :update, id: "1", resource_name => resource_attributes
    end    
  
    context "with valid attributes" do

      before(:each) do                
        @current_resource.stub(:update_attributes).and_return(true)          
      end
      
      it "redirects to index action" do
        put :update, id: "1"
        response.should redirect_to collection_path
      end
      
      it "sets flash message" do
        put :update, id: "1"
        flash[:notice].should_not be_empty
      end        
      
    end

    context "with invalid attributes" do

      before(:each) do                
        @current_resource.stub(:update_attributes).and_return(false)          
      end
      
      it "re-renders edit template" do
        put :update, id: "1"
        response.should render_template :edit
      end               
      
    end
  end
  
  describe "DELETE #destroy" do
    
    before(:each) do
      @current_resource = resource    
      resource_class.stub(:find).and_return(@current_resource)
      @current_resource.stub(:destroy)     
    end
    
    it "locates requested resource" do
      resource_class.should_receive(:find).with("1")
      delete :destroy, id: "1"
    end
    
    it "destroys resource" do
      @current_resource.should_receive(:destroy)
      delete :destroy, id: "1"
    end
    
    it "redirects to index action" do
      put :destroy, id: "1"
      response.should redirect_to collection_path
    end
  
    context "when destroy succeeded" do 
      before(:each) do
        @current_resource.stub(:destroy).and_return(true)
      end

      it "sets flash notice" do
        put :destroy, id: "1"
        flash[:notice].should_not be_empty
      end
    end
    
    context "when destroy fails" do 
      before(:each) do
        @current_resource.stub(:destroy).and_return(false)
      end

      it "sets flash error" do
        put :destroy, id: "1"
        flash[:alert].should_not be_empty
      end
    end      
  end
end
