class AddImagesUpdatedAtToTumblrBlogs < ActiveRecord::Migration
  def change
    add_column :tumblr_blogs, :images_updated_at, :datetime
  end
end
