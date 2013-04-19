class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :url
      t.references :tumblr_blog

      t.timestamps
    end
  end
end
