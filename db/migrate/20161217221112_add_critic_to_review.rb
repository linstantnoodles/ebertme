class AddCriticToReview < ActiveRecord::Migration[5.0]
  def change
    add_reference :reviews, :critic, foreign_key: true
  end
end
