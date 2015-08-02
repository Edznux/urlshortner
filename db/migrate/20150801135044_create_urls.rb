class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :hash_string
      t.string :link_to

      t.timestamps null: false
    end
  end
end
