require File.join(Rails.root, 'db', 'migrate', '20161218023823_add_rogert_ebert_movie_reviews.rb')

describe 'AddRogerEbertMovieReviews' do

    describe '#up' do
        it 'should create roger ebert critic' do
            assert_equal 0, Critic.count
        end
    end

end