require 'rubygems'
require 'json'
require 'yaml'
require 'rest_client'

$base_url = "www.pushray.com:8080/api/v1/"

# Function that create channel with rest_api and check if channel exsists first

def create_channel(channel)
  puts "running create_channel, channel = #{channel.inspect}"
  key_check =  RestClient.get "#{$base_url}/channels/#{channel["key"]}" #space should be escaped :)
  if  key_check.nil? || key_check['key'].nil?
    #params = { 'key' => channel["key"], 'name' => channel["name"], 'description' => channel["description"] },
    result = RestClient.post "#{$base_url}/channels/create", channel.to_json, :content_type => :json
    puts result.inspect # Test for checking that request is valid
  else 
    puts "Error, Channel is already exsists - #{key_check.inspect}"
  end
end

def create_message(message)
  puts "running create_message, message = #{message.inspect}"
    #params = { 'key' => message["key"], 'name' => message["name"], 'description' => message["description"] },
    result = RestClient.post "#{$base_url}/messages/create/", message.to_json, :content_type => :json
    puts result.inspect # Test for checking that request is valid
end



channel_list = YAML.load_file("#{File.dirname(__FILE__)}/poll_list.yml")
channel_list.each do |channel|
           create_channel(channel)
end 

messages_list = YAML.load_file("#{File.dirname(__FILE__)}/twitter_accounts.yml")
messages_list.each do |message|
           create_message(message)
end 
