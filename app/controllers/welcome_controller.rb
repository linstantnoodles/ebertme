class WelcomeController < ApplicationController
    helper_method :movie_providers

    def index
        @providers = Provider.all
        @review_params = params.fetch(:movie, {}).permit(:provider_id, :title)
        @title = @review_params[:title]
        @provider_id = @review_params[:provider_id]
        @reviews = Review.search_by_params(@review_params)
            .where(rating: 4..5)
            .distinct
            .page(params[:page])
            .per(10)
        @reviews.each do |review|
            create_movie_providers(review.movie)
        end
    end

    def create_movie_providers(movie)
        if !movie.providers.empty?
            return
        end
        title = movie.title
        keyword = CGI.escape(title.downcase)
        uri = URI("http://www.yidio.com/redesign/json/search.php?limit=4&keyword=#{keyword}")
        response = Net::HTTP.get(uri)
        if response.eql? 'null'
            return
        end
        parsed_response = JSON.parse(response)
        results = parsed_response['response']
        if results.empty?
            return
        end
        results.each do |result|
            result_name = result['name']
            result_year = result['year']
            if result_name.downcase.eql? title.downcase
                target_id = result['id']
                target_url = result['url']
                link_id = target_id
                link_name = target_url.split('/').last(2).join('/')
                uri = URI('http://www.yidio.com/ajax_load_movie_provider_links.php')
                params = {'link_id': link_id, 'link_name': link_name}
                response = Net::HTTP.post_form(uri, params)
                body = response.body
                html_doc = Nokogiri::HTML(body)

                provider_list = html_doc.xpath("//*[@data-provider-name]")
                provider_list.each do |provider|
                    provider_name = provider['data-provider-name']
                    puts "Adding provider #{provider_name} to movie #{movie.title}"
                    movie_provider = Provider.find_or_create_by(name: provider_name)
                    movie.providers << movie_provider
                end
            end
        end
    end

end
