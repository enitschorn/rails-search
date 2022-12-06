class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.text :description
      t.integer :rating
      t.references :flat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
