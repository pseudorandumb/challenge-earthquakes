require 'net/http'
require 'rubygems'
require 'bundler/setup'
require 'yaml'
Bundler.require(:default, :development)

require './earthquake'

env = ENV['ENV'] || "development"

ActiveRecord::Base.establish_connection(YAML.load_file("./db/config.yml")[env])