require 'capistrano/setup'

require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/passenger'
require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/sidekiq'
require 'thinking_sphinx/capistrano'
require 'whenever/capistrano'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
