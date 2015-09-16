class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password
      t.string :password_digest
      t.string :name
      t.string :access_token

      t.timestamps null: false
    end
  end
end
