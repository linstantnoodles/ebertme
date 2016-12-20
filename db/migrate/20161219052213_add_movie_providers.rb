class AddMovieProviders < ActiveRecord::Migration[5.0]
    def up
        movies_without_providers = Movie.left_outer_joins(:providers).where(providers: {id: nil}).limit(100)
        movies_without_providers.each do |movie|
            title = movie.title
            keyword = CGI.escape(title.downcase)
            uri = URI("http://www.yidio.com/redesign/json/search.php?limit=4&keyword=#{keyword}")
            response = Net::HTTP.get(uri)
            if response.eql? 'null'
                next
            end
            parsed_response = JSON.parse(response)
            results = parsed_response['response']
            if results.empty?
                next
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
end
