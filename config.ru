require 'sprockets'

$LOAD_PATH.unshift File.expand_path('../app', __FILE__)
require 'controller/racker'



assets = Sprockets::Environment.new do |env|
  
  env.append_path 'app/assets/stylesheets'
  env.css_compressor = :scss
end

map '/assets' do
  run assets
end

map '/' do
  run Racker
end

#use Rack::Static, urls: ['/stylesheets'], root: 'app/assets'
#run Racker