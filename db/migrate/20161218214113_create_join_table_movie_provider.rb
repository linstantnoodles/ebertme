class CreateJoinTableMovieProvider < ActiveRecord::Migration[5.0]
  def change
    create_join_table :Movies, :Providers do |t|
      t.index [:movie_id, :provider_id]
      t.index [:provider_id, :movie_id]
    end
  end
end
