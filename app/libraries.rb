RACK_ENV  = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
RACK_ROOT = File.expand_path(File.dirname(__FILE__) + '/..')

# std lib
require 'open3'
require 'uri'
require 'base64'
require 'digest'
require 'zlib'
require "rexml/document"

# bundled gems
require 'sinatra/base'
require 'yajl'
require 'curb'
require 'mustache/sinatra'
require 'sinatra/auth/github'
require 'coderay'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# hurl
require 'helpers'

require 'models/db'
require 'models/user'

require 'views/layout'

module Sinatra
  module Auth
    module Local
      module Helpers
        def warden
          env['warden']
        end

        def authenticate!(*args)
          warden.authenticate!(*args)
        end

        def authenticated?(*args)
          warden.authenticated?(*args)
        end

        def logout!
          warden.logout
        end

        # The authenticated user object
        #
        # Supports a variety of methods, name, full_name, email, etc
        def github_user
          warden.user
        end
      end

      def self.registered(app)
        Warden::Strategies.add(:local) do
          def authenticate!
            success!(Warden::Github::Oauth::User.new({
		'login' => 'local', 'id' => 'local' }, 'localtoken'))
          end
        end

        app.use Warden::Manager do |manager|
          manager.default_strategies :local
        end

        app.helpers Helpers
      end
    end
  end
end
