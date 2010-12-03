require 'erb'
require 'yaml'

config = YAML::load(File.read('config.yml'))

get '/' do
  @repositories = Pathname.glob("#{config[:git_repositories_location]}/*").map(&:basename)
  erb :'index.html'
end

get '/patch' do
  content_type 'text/plain'
  `cd #{config[:git_repositories_location]}/#{params[:repository]} && git format-patch -k #{params[:commit]}..head --binary --stdout`
end
