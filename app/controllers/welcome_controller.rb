class WelcomeController < ApplicationController
    helper_method :movie_providers

    def index
        #roger_ebert = Critic.includes(reviews: [:movie]).find_by(name: 'Roger Ebert')
        @reviews = Review.includes(:movie).where(rating: 4..5)
            .page(params[:page])
            .per(20)
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
