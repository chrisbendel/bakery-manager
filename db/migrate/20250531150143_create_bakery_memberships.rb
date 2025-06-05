class CreateBakeryMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :bakery_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bakery, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
