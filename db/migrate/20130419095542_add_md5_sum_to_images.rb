class AddMd5SumToImages < ActiveRecord::Migration
  def change
    add_column :images, :md5_sum, :string
  end
end
