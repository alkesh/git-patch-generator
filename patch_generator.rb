require 'erb'
require 'escape'
require 'yaml'

config = YAML::load(File.read('config.yml'))

get '/' do
  @repositories = Pathname.glob("#{config[:git_repositories_location]}/*").map(&:basename)
  erb :'index.html'
end

get '/patch' do
  content_type 'text/plain'
  if params[:commit] =~ /[^a-fA-F\d]/
    "invalid commit: #{params[:commit]}"
  else
    cd_command = Escape.shell_command ['cd', "#{config[:git_repositories_location]}/#{params[:repository]}"]
    `#{cd_command} && git format-patch -k #{params[:commit]}..head --binary --stdout`
  end
end
