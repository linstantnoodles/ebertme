class AddPosterImgSrcToMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :poster_img_src, :string
  end
end
