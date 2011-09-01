require 'sinatra'

post '/' do
  "Hello World! from POST"
end

get '/' do
  erb :index
end