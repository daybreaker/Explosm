require 'open-uri'
require 'nokogiri'
require 'json'
require 'sinatra'

def refresh_results
  authors = %w(Rob Dave Matt Kris)
  author_url = 'http://www.explosm.net/comics/author/'
  fb_url = "https://graph.facebook.com/http://www.explosm.net"

  total_results = {}

  authors.each do |a|
    author_history = Nokogiri::HTML(open(author_url + a))
    author_comics = author_history.css('table a').collect{|x| x.attributes['href'].text}
    
    total_author_comics = author_comics.size
    total_author_shares = 0

    puts "Total Comics by #{a}: #{total_author_comics}\n"
    
    count = 1
    total_shares = 0
    
    author_comics.each do |c|
    	response = open(fb_url + c)
    	result = JSON.parse(response.string)
    	total_shares += result['shares']
    	puts "on: " + count.to_s + "\n" if (count%30 == 0)
    	
      puts  ((count/(total_author_comics/10).to_i)*10).to_s + "% done -- on comic #{count}" + " for an average " + (total_shares/count).to_s + " facebook shares so far." if ((count%((total_author_comics/10).to_i)) == 0)

      count += 1
    end
    
    total_results[a] = {'total_comics' => total_author_comics, 'average_shares' => total_shares/total_author_comics}
  end

  total_results.each do |name, info|
    puts name + "did #{info['total_comics']} for an average #{info['average_shares']} facebook shares."
  end
end

get '/' do
  erb :index
end

