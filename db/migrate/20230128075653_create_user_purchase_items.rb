class CreateUserPurchaseItems < ActiveRecord::Migration[7.0]
  def change
    create_table :user_purchase_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :user_list_item, null: false, foreign_key: true
      t.numeric :point

      t.timestamps
    end
  end
end
