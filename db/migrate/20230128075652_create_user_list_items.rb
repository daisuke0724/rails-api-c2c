class CreateUserListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_list_items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.numeric :point

      t.timestamps
    end
  end
end
