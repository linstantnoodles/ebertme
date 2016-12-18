class ChangePosterImgSrc < ActiveRecord::Migration[5.0]
  def change
        rename_column :movies, :poster_img_src, :poster_img_url
  end
end
