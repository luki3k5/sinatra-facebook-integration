require 'sinatra'

post '/' do
  "Hello World! from POST"
end

get '/' do
  "Hello World! from GET"
end