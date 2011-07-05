require 'open-uri'
require 'nokogiri'
require 'json'
require 'data_mapper'
require 'sinatra'

configure do
  set :environment, 'development'
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'mysql://daybreaker:groovy@localhost/explosm_development')
  
  
class Comic
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :comic_id,   Integer   
  property :comic_url,  String
  property :author,     String
  property :date,       String
  property :likes,      Integer
  property :created_at, DateTime  # A DateTime, for any date you might like.
end

DataMapper.auto_upgrade!
    
AUTHORS = %w(Rob Dave Matt Kris)
AUTHOR_URL = 'http://www.explosm.net/comics/author/'
FB_URL = "https://graph.facebook.com/http://www.explosm.net"

def author_comics(author)
  x = Nokogiri::HTML(open(AUTHOR_URL + author))
  c = x.css('table a').collect{|x| x.attributes['href'].text}
  c
end

get '/' do
  @authors = AUTHORS
  erb :index
end

get '/makefile' do
  comics = {}
  
  AUTHORS.each do |author|
    
    comics = author_comics(author)
    comics.each do |comic|
      response = open(FB_URL + comic)
    	result = JSON.parse(response.string)
    	c = Comic.create(
    	    :comic_id     => comic.split('/')[2].to_i,  
          :comic_url    => comic,
          :author       => author,
          :date         => '',
          :likes        => result['shares'].to_i,
          :created_at   => Time.now
      )
      puts c.saved?
      puts 'Author: ' + c.author + " Comic: " + c.comic_id.to_s + " Likes: " + c.likes.to_s
    end
  end
end


