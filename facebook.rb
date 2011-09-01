require 'sinatra'


set :views, File.dirname(__FILE__) + '/views'

post '/' do
  "Hello World! from POST"
end

get '/' do
  erb :index
end