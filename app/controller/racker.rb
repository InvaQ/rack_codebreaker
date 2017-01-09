#require 'erb'
require 'haml'
require 'codebreaker'
require 'yaml'
require 'pry'

class Racker
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game = start_game
    @request.session[:try] ||= {}
    @request.session[:player] ||= {}
  end


  def response
    case @request.path
      when '/' then render('index')
      when '/game' then render('game')
      when '/rules' then render('rules')
      when '/hint' then hint
      when '/new_player' then new_player
      when '/check_guess' then check_guess
      when '/play_again' then play_again
      when '/save' then save_score
      when 'show_statistics' then render('statistics')
    else Rack::Response.new('Not Found', 404)
    end
  end
  
  def session_data(data)
    @request.session[data]
  end  

  def render(template)
    path = File.read("app/views/#{template}.html.haml")
    page = Haml::Engine.new(path).render(binding)
    Rack::Response.new(page)
  end

  def new_player
    @request.session[:name] = (@request.params['player'].match(/\A[[:space:]]*\z/) ? 'John Doe': @request.params['player'])
    @request.session[:player][session_data(:name)] = Codebreaker::Gamer.new(session_data(:name)).name
    redirect_to('/game')
  end

  def start_game
    @request.session[:game] ||= Codebreaker::Game.new
    #binding.pry
  end

  def hint
    @request.session[:hint] = @game.get_hint
    #binding.pry
    redirect_to('/game')
  end

  def check_guess
    @request.session[:guess] = @request.params['guess']
    @request.session[:try][session_data(:guess)] = @game.break_the_code(session_data(:guess))
    redirect_to('/game')
  end

  def play_again
    @request.session.clear
    redirect_to('/')
  end

  def redirect_to(path)
    Rack::Response.new do |response|
      response.redirect(path)
    end
  end

  def save_score
    path = File.open('score.yml', 'a')
    write_data(path)
    redirect_to('/game')
  end

  def write_data(file)
    buffer = ["Name: #{@request.session[:player][session_data(:name)]}", ["hints: #{@game.hints}", "tries: #{@game.tries_used}"]]
    binding.pry       
    file.write buffer.to_yaml       
  end


end