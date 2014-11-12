class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :api_url
      t.string :user
      t.string :password
      t.string :token
      t.string :ga_token

      t.timestamps
    end
  end
end
