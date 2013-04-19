require 'spec_helper'

describe "tumblr blogs" do
  it "routes to root path" do
    root_path.should == "/"
    get(root_path).should route_to("tumblr_blogs#index")
  end
  
  it "do not route to #show" do
    get('/tumblr_blogs/1').should_not be_routable
  end
  
  it "routes to #index" do
    tumblr_blogs_path.should == "/tumblr_blogs"
    get(tumblr_blogs_path).should route_to("tumblr_blogs#index")
  end
  
  it "routes to #new" do
    new_tumblr_blog_path.should == "/tumblr_blogs/new"
    get(new_tumblr_blog_path).should route_to("tumblr_blogs#new")
  end
  
  it "routes to #create" do
    tumblr_blogs_path.should == "/tumblr_blogs"
    post(tumblr_blogs_path).should route_to("tumblr_blogs#create")
  end
  
  it "routes to #edit" do
    edit_tumblr_blog_path(id: 1).should == "/tumblr_blogs/1/edit"
    get(edit_tumblr_blog_path(id: 1)).should route_to(
      action: 'edit',
      controller: 'tumblr_blogs',
      id: '1'
    )
  end
  
  it "routes to #update" do
    edit_tumblr_blog_path(id: 1).should == "/tumblr_blogs/1/edit"
    put(tumblr_blog_path(id: 1)).should route_to(
      action: 'update',
      controller: 'tumblr_blogs',
      id: '1'
    )
  end
  
  it "routes to #delete" do
    tumblr_blog_path(id: 1).should == "/tumblr_blogs/1"
    delete(tumblr_blog_path(id: 1)).should route_to(
      action: 'destroy',
      controller: 'tumblr_blogs',
      id: '1'
    )
  end
  
end