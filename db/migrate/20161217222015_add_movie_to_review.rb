class AddMovieToReview < ActiveRecord::Migration[5.0]
  def change
    add_reference :reviews, :movie, foreign_key: true
  end
end
