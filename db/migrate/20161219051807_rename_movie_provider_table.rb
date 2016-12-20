class RenameMovieProviderTable < ActiveRecord::Migration[5.0]
  def change
     rename_table :Movies_Providers, :movies_providers
  end
end
