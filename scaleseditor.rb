#!/usr/bin/env ruby
require 'sinatra'
require 'erubis'

require './zaozi'

z = ZaoZi.new()

configure do
  set :views, 'scaleseditor'
  set :public_folder, 'scaleseditor'
  set :static, true
end

get "/" do
  erb :main
end

get "/load" do
  content_type :json
  z.scaledatajson(params[:cmd])
end