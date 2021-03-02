require 'json'
require "sinatra"
require "sinatra/reloader"
require 'fast_jsonapi'

require 'sinatra/activerecord' 
# this will load models only after requiring activerecord
Dir[File.join('.', 'app', '**', '*.rb')].sort.each { |f| require f }

module Ads
  class App < Sinatra::Base

    configure do
      register Sinatra::Reloader
      register Sinatra::ActiveRecordExtension
    end

    get '/' do
      ads = Ad.order(updated_at: :desc).page(params['page'])
      serializer = AdSerializer.new(ads, links: pagination_links(ads))

      serializer.serialized_json
    end

    helpers PaginationLinks
    
  end

end
