class Review < ApplicationRecord
    belongs_to :critic
    belongs_to :movie

    scope :search_by_params, -> (params) {
        search_by_provider(params[:provider_id])
            .search_by_title(params[:title])
    }

    scope :search_by_provider, -> (provider_id) {
        return all if provider_id.blank?
        includes(movie: [:providers])
            .left_outer_joins(movie: :providers)
            .where(providers: {id: provider_id})
    }

    scope :search_by_title, -> (title) {
        return all if title.blank?
        includes(:movie)
            .left_outer_joins(:movie)
            .where("movies.title ILIKE ?", "%#{title}%")
    }

    scope :order_by, -> (sort_method) {
        return all if sort_method.blank?
        date_order = (sort_method == 'newest') ? 'date DESC' : 'date ASC'
        includes(:movie).order("#{date_order}")
    }
end
