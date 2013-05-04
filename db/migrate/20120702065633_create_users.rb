class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :shadow
      t.integer :score, :default => 0

      t.timestamps
    end
  end
end
