# frozen_string_literal: true

require_relative 'config/environment'

map '/ad' do
  run AdRoutes
end
