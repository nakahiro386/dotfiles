# default_values = YAML.load(File.read("#{File.dirname(__FILE__)}/anyenv.yaml"))

SCRIPT_PATH = File.expand_path(__FILE__)

define :managed_file, fragment: nil, comment: nil, insertbefore: false do
  comment = params[:comment]
  fragment_start = "#{comment} mitamae managed #{SCRIPT_PATH} START"
  fragment_end = "#{comment} mitamae managed #{SCRIPT_PATH} END"
  fragment = <<-"EOS"
#{fragment_start}
#{params[:fragment].chomp}
#{fragment_end}
  EOS
  mitamae_managed = /^#{Regexp.escape(fragment_start)}.+#{Regexp.escape(fragment_end)}\n/im

  file params[:name] do
    action [:create, :edit]
    block do |content|
      if content =~ mitamae_managed
        content.gsub!(mitamae_managed, fragment)
      else
        content.insert(params[:insertbefore] ? 0 : -1, fragment)
      end
    end
  end
end

cwd = File.expand_path("..", __FILE__)
files = File.join(cwd, 'files')
node[:files] = files

p node[:platform] # => "ubuntu"
p node[:platform_version] # => "18.04"

user = ENV['USER']
user_info = node['user'][user]
p user_info

home = user_info[:directory]
node[:home] = home

home_bin = File.join(home, 'bin')
node[:home_bin] = home_bin

home_config = ENV['XDG_CONFIG_HOME']
home_config ||= File.join(home, '.config')
node[:home_config] = home_config

include_recipe 'recipe/home'
include_recipe 'recipe/bash'

include_recipe 'recipe/appimage'
include_recipe 'recipe/lazygit'
include_recipe 'recipe/git_clone'
include_recipe 'recipe/vim'

include_recipe 'anyenv'
