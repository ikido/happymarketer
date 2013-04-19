class AddStateToImages < ActiveRecord::Migration
  def change
    add_column :images, :state, :string
  end
end
