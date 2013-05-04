class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :message
      t.text :url
      t.integer :status, :default => 0
      t.string :lock, :default => 'false'
      t.string :attachment
      t.references :user

      t.timestamps
    end
    add_index :requests, :user_id
  end
end
