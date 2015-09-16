class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.integer :user_id
      t.string :path
      t.string :tiny_path

      t.timestamps null: false
    end
  end
end
