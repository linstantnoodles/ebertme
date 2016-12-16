class WelcomeController < ApplicationController
    def index
        review_list = []
        (1).upto(5) do |current_page|
            url_template = "http://www.rogerebert.com/reviews?great_movies=0&no_stars=0&order=newest&filters%5Bgreat_movies%5D%5B%5D=&filters%5Bno_stars%5D%5B%5D=&filters%5Bno_stars%5D%5B%5D=1&filters%5Btitle%5D=&filters%5Breviewers%5D%5B%5D=50cbacd5f3b43b53e9000003&filters%5Bgenres%5D=&filters%5Bstar_rating%5D%5B%5D=4.0&filters%5Bstar_rating%5D%5B%5D=4.0&page=#{current_page}&sort%5Border%5D=oldest"
            uri = URI(url_template)
            html = Net::HTTP.get(uri)
            html_doc = Nokogiri::HTML(html)
            reviews = html_doc.css('.review.movie')
            reviews.each do |review|
                review_info = {}
                children = review.children
                poster = children.css('.poster')[0]
                review_path = poster.attributes["href"].value
                title = children.css('.title')[0]
                byline = children.css('.byline')[0]
                release_year = children.css('.release-year')[0]
                star_rating = children.css('.star-rating').children
                review_list << {
                   'title': title.content.strip,
                   'reviewer': byline.content.strip,
                   'release_year': release_year.content.strip.tr('()',''),
                   'rating': star_rating.length,
                   'url': "http://www.rogerebert.com#{review_path}"
                }
            end
        end
        @reviews = review_list
    end
end
