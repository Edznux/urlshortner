class AddViewsToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :views, :integer
  end
end
