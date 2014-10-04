require 'rubygems'
require 'oauth'
require 'json'
require 'time'
require 'yaml'


# Loading keys from extrenal file

keys = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")
twitter_consumer_key =  keys["api_keys"]["twitter_consumer_key"]
twitter_consumer_secret = keys["api_keys"]["twitter_consumer_secret"]
twitter_access_token = keys["api_keys"]["twitter_access_token"] 
twitter_access_token_secret =  keys["api_keys"]["twitter_access_token_secret"]

# Now you will fetch /1.1/statuses/user_timeline.json,
# returns a list of public Tweets from the specified
# account.

baseurl = "https://api.twitter.com"
path = "/1.1/statuses/user_timeline.json"
query = URI.encode_www_form(
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
http = Net::HTTP.new address.host, address.port
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER


consumer_key ||= OAuth::Consumer.new "#{twitter_consumer_key}", "#{twitter_consumer_secret}"
access_token ||= OAuth::Token.new "#{twitter_access_token}", "#{twitter_access_token_secret}"

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

