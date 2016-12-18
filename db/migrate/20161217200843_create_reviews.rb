class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.datetime :date
      t.string :url

      t.timestamps
    end
  end
end
