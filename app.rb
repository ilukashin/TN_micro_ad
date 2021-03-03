require 'json'
require "sinatra"
require "sinatra/reloader"
require 'fast_jsonapi'
require 'byebug'

require 'sinatra/activerecord' 
# this will load models only after requiring activerecord
Dir[File.join('.', 'app', '**', '*.rb')].sort.each { |f| require f }

module Ads
  class App < Sinatra::Base

    configure do
      register Sinatra::Reloader
      register Sinatra::ActiveRecordExtension
      register Kaminari::Helpers::SinatraHelpers
    end

    get '/' do
      ads = Ad.order(updated_at: :desc).page(params['page'])
      serializer = AdSerializer.new(ads, links: pagination_links(ads))

      serializer.serialized_json
    end


    post '/ads' do        
      result = Ad.create!(ad_params)
  
      if result.errors.any?
        422
      else
        GeocodingService.new.push_to_que(result)
        serializer = AdSerializer.new(result)
        [201, serializer.serialized_json]
      end
    end

    helpers PaginationLinks, Common
    
  end
end
