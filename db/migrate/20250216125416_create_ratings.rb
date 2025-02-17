class CreateRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :ratings do |t|
      t.integer :value, null: false
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :ratings, [:post_id, :user_id], unique: true
    add_check_constraint :ratings, 'value >= 1 AND value <= 5'
  end
end
