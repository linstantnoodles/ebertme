class AddRogertEbertMovieReviews < ActiveRecord::Migration[5.0]
    def up
        critic = Critic.create(name: "Roger Ebert")
        current_page = 1
        while true
            url_template = "http://www.rogerebert.com/reviews?great_movies=0&no_stars=0&order=newest&filters%5Bgreat_movies%5D%5B%5D=&filters%5Bno_stars%5D%5B%5D=&filters%5Bno_stars%5D%5B%5D=1&filters%5Btitle%5D=&filters%5Breviewers%5D%5B%5D=50cbacd5f3b43b53e9000003&filters%5Bgenres%5D=&filters%5Bstar_rating%5D%5B%5D=1.0&filters%5Bstar_rating%5D%5B%5D=4.0&page=#{current_page}&sort%5Border%5D=oldest"
            uri = URI(url_template)
            html = Net::HTTP.get(uri)
            html_doc = Nokogiri::HTML(html)
            reviews = html_doc.css('.review.movie')
            if reviews.length == 0
                break
            end
            reviews.each do |review|
                children = review.children

                poster = children.css('.poster')[0]
                poster_img_url = poster.children[0].attributes['src'].value
                review_path = poster.attributes["href"].value
                title = children.css('.title')[0]
                byline = children.css('.byline')[0]

                great_movie = review.attributes['class'].value.include?('great-movie')
                star_rating = great_movie ? 5 : children.css('.star-rating').children.length

                release_year = children.css('.release-year')[0]
                review_release_year = release_year.content.strip.tr('()','') unless release_year.nil?

                movie = Movie.create(
                    title: title.content.strip,
                    poster_img_url: poster_img_url
                )
                Review.create(
                    rating: star_rating,
                    date: "#{review_release_year}-01-01",
                    url: "http://www.rogerebert.com#{review_path}",
                    critic: critic,
                    movie: movie
                )
            end
            current_page += 1
        end
    end
  def down
    Review.destroy_all
    Critic.destroy_all
    Movie.destroy_all
  end
end

