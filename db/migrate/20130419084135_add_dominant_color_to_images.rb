class AddDominantColorToImages < ActiveRecord::Migration
  def change
    add_column :images, :dominant_color, :integer
  end
end
