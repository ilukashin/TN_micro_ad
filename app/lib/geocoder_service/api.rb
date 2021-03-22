require 'json'

module GeocoderService
  module Api

    def get_coordinates(city)
      response = connection.post do |request|
        request.params['city'] = city
      end

      if response.success?
        JSON.parse(response.body)
      else
        [nil,nil]
      end

    end    
  end
end
