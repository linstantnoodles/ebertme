class WelcomeController < ApplicationController
    def index
        review_list = []
        (1).upto(1) do |current_page|
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
                   'url': "http://www.rogerebert.com#{review_path}",
                   'providers': format_provider_list(movie_providers(title.content.strip))
                }
            end
        end
        @reviews = review_list
    end

    def format_provider_list(providers)
        providers.join(', ')
    end

    def movie_providers(title)
        providers = []
        keyword = CGI.escape(title.downcase)
        url = "http://www.yidio.com/redesign/json/search.php?limit=4&keyword=#{keyword}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        if response.eql? 'null'
            return []
        end
        parsed_response = JSON.parse(response)
        results = parsed_response['response']
        if results.empty?
            return []
        end
        results.each do |result|
            result_name = result['name']
            result_year = result['year']
            if result_name.downcase.eql? title.downcase
                target_id = result['id']
                target_url = result['url']
                link_id = target_id
                link_name = target_url.split('/').last(2).join('/')
                url = 'http://www.yidio.com/ajax_load_movie_provider_links.php'
                uri = URI(url)
                params = {'link_id': link_id, 'link_name': link_name}
                response = Net::HTTP.post_form(uri, params)
                body = response.body
                html_doc = Nokogiri::HTML(body)
                provider_list = html_doc.xpath("//*[@data-provider-name]")
                provider_list.each do |provider|
                    providers << provider['data-provider-name']
                end
            end
        end
        providers
    end

end
