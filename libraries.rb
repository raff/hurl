require 'tempfile'
require 'open3'
require 'uri'
require 'base64'
require 'digest'
require 'zlib'

def rubygem(file)
  gem, file = file.values[0], file.keys[0] if file.respond_to? :keys
  require file
rescue LoadError
  raise "** Please `gem install #{gem || file.split('/')[0]}`"
end

rubygem 'sinatra/base'
rubygem 'yajl' => 'yajl-ruby'
rubygem 'curb'
rubygem 'redis'
rubygem 'mustache/sinatra'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/vendor'
require 'albino'

require 'models/model'
require 'models/user'

require 'helpers'
require 'views/layout'
require 'views/stats'
