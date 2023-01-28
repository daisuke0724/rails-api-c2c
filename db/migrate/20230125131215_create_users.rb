class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name

      t.timestamps
    end
    add_index :users, :email
  end
end