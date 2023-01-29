class CreateUserListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_list_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.numeric :point
      t.references :user_purchase_items, null: true, foreign_key: true

      t.integer :lock_version, default: 0
      t.timestamps
    end
  end
end
