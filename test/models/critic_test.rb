require 'test_helper'

class CriticTest < ActiveSupport::TestCase
  test "#all_reviews" do
    critic = Critic.create(name: "test critic")
    movie_1 = Movie.create(title: 'movie test 1')
    movie_2 = Movie.create(title: 'movie test 2')
    review_1 = Review.create(rating: 1, movie: movie_1, critic: critic)
    review_2 = Review.create(rating: 2, movie: movie_2, critic: critic)
    assert_equal 1, critic.all_reviews.count
    end
end
