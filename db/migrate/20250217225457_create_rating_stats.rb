class CreateRatingStats < ActiveRecord::Migration[7.2]
  def change
    create_table :rating_stats do |t|
      t.references :post, null: false, foreign_key: true, index: { unique: true }
      t.integer :ratings_sum, default: 0, null: false
      t.integer :ratings_count, default: 0, null: false
      t.float :average_rating, default: 0.0, null: false

      t.timestamps
    end

    add_index :rating_stats, :average_rating, order: { average_rating: :desc }
  end
end
