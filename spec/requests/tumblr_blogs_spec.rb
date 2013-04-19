require 'spec_helper'

describe "Tumblr blogs" do

  
  it "list all entries" do
    tumblr_blog = FactoryGirl.create(:tumblr_blog)
    visit root_path
    click_link 'Tumblr Blogs'
    
    page.should have_content tumblr_blog.name
  end
  
  it "creates new entry" do        
    visit root_path
    click_link 'Tumblr Blogs'
    click_link 'New'
    page.should have_content 'New Tumblr Blog'
    
    fill_in 'Name', with: 'testblog'
    click_button 'Save'
    
    page.should have_content 'Tumblr Blog successfully created'
    page.should have_content 'testblog'
  end  

  it "shows errors when new entry is invalid" do
    visit root_path
    click_link 'Tumblr Blogs'
    click_link 'New'
    
    test_with_common_invalid_attributes(:create, 'TumblrBlog')
    
  end
  
  it "allows to edit entry" do
    tumblr_blog = FactoryGirl.create(:tumblr_blog)
            
    visit root_path
    click_link 'Tumblr Blogs'
    
    within("tr", :text => tumblr_blog.name) do
      click_link 'Edit'
    end
    
    fill_in 'Name', with: 'testblog'
    click_button 'Save'
    
    page.should have_content 'Tumblr Blog successfully updated'
    page.should have_content 'testblog'
  end
  
  it "shows errors when updated entry name is invalid" do
    tumblr_blog = FactoryGirl.create(:tumblr_blog)
            
    visit root_path
    click_link 'Tumblr Blogs'
    
    within("tr", :text => tumblr_blog.name) do
      click_link 'Edit'
    end
    
    test_with_common_invalid_attributes(:update, 'TumblrBlog')
  end
  
  it "deletes entry" do
    tumblr_blog = FactoryGirl.create(:tumblr_blog)
            
    visit root_path
    click_link 'Tumblr Blogs'
    
    within("tr", :text => tumblr_blog.name) do
      click_link 'Delete'
    end
    
    page.should have_content 'Tumblr Blog successfully deleted'
    page.should_not have_content tumblr_blog.name
  end
  
end

def test_with_common_invalid_attributes(action_name, resource_name)
  @action_name = action_name
  @resource_name = resource_name
  
  try_to_save_attribute('Name', '', "can't be blank")
  try_to_save_attribute('Name', 'some name', "is invalid")
end

def try_to_save_attribute(attribute_name, attribute_value, error_text)
  fill_in attribute_name.titleize, with: attribute_value
  click_button 'Save'
  
  # Adjacent siblings
  # http://www.w3.org/TR/CSS2/selector.html#adjacent-selectors
  find(:css, ".#{@resource_name.underscore}_#{attribute_name.underscore} span.error")
    .should have_content error_text
    
  page.should_not have_content "successfully #{@action_name.to_s}ed"
end