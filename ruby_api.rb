require 'rubygems'
require 'oauth'
require 'json'
require 'time'

# Now you will fetch /1.1/statuses/user_timeline.json,
# returns a list of public Tweets from the specified
# account.
baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/user_timeline.json"
query   = URI.encode_www_form(
    "screen_name" => "rifforon",
    "count" => 1,
)
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new address.request_uri

# Print data about a list of Tweets
def print_timeline(tweets)
  tweets.each do |tweet|
    
    d = Time.parse(tweet['created_at']).to_i
    tl = Time.now.to_i
    diff = tl - d 
    if diff < 60
    puts "#{tweet['user']['name']} , #{tweet['text']} , #{tweet['id']}"
    else 
    puts "No tweets were made in the last minute"
    end
  end
end


# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER


consumer_key ||= OAuth::Consumer.new "kgjz5QmsEqxgtHCqblr77rDWJ", "gt1IU9fTZCNgkd1id9BEsid2O2ZxmlAREIiVXSuEIJ6ZzJADhr"
access_token ||= OAuth::Token.new "2202072970-ClC7hTo4epcTduNH7GMcsTi4tJDqwMyl3egSIEU", "ROQRHq49MdKjid3jZwk6i1ExqISPwaMij0ROHsd9a49QD"

# Issue the request.
request.oauth! http, consumer_key, access_token
http.start
response = http.request request
# Parse and print the Tweet if the response code was 200
tweets = nil
if response.code == '200' 
  tweets = JSON.parse(response.body)
#  puts tweets
  print_timeline(tweets)
end
nil

