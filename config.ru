require 'sprockets'

$LOAD_PATH.unshift File.expand_path('../app', __FILE__)
require 'controller/racker'
use Rack::Reloader
assets = Sprockets::Environment.new do |env|
  
  env.append_path 'app/assets/stylesheets'
  env.css_compressor = :scss
end

map '/assets' do
  run assets
end
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'rack_cb'
map '/' do
  run Racker
end
