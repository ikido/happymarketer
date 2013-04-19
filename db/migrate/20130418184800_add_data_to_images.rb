class AddDataToImages < ActiveRecord::Migration
  def change
    add_column :images, :data, :string
  end
end
