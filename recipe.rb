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

def self.dir_entries(path)
  entries = Dir.entries(path)
  entries.delete('.')
  entries.delete('..')
  return entries
end

cwd = File.expand_path("..", __FILE__)
files = File.join(cwd, 'files')

p node[:platform] # => "ubuntu"
p node[:platform_version] # => "18.04"

user = ENV['USER']
user_info = node['user'][user]
p user_info
home = user_info['directory']

# dirs
xdg_user_dirs = []
tmxu_use_xdg = run_command('printf "$(tmux -V | cut -d' ' -f2 )\n3.2" | sort -C -V', error: false).exit_status

local = File.join(home, '.local')
xdg_user_dirs << local
xdg_user_dirs << File.join(local, 'bin')
xdg_user_dirs << File.join(local, 'src')
xdg_user_dirs << File.join(local, 'lib')
xdg_user_dirs << ENV['XDG_DATA_HOME'] ||= File.join(local, 'share')
xdg_user_dirs << ENV['XDG_STATE_HOME'] ||= File.join(local, 'state')

xdg_user_dirs << ENV['XDG_CACHE_HOME'] ||= File.join(home, '.cache')

config = ENV['XDG_CONFIG_HOME']
config ||= File.join(home, '.config')
xdg_user_dirs << config

config_pip = File.join(config, 'pip')
xdg_user_dirs << config_pip

config_tmux = File.join(config, 'tmux')
if tmxu_use_xdg
  xdg_user_dirs << config_tmux
end

xdg_user_dirs.each do |d|
  directory d do
    action :create
  end
end

# git_config
managed_file File.join(home, '.gitconfig') do
  fragment <<-"EOS"
[include]
	path = #{File.join(files, 'gitconfig')}
  EOS
  comment ";"
  insertbefore true
end

def self.get_bash_fragment(fragment_dir)
  return <<-"EOS"
fragment_dir="#{fragment_dir}"
if [ -d ${fragment_dir} ] ; then
    for f in ${fragment_dir}/* ; do
        [ -r "$f" ] && . "$f"
    done
    unset f
fi
unset fragment_dir
  EOS
end

# .profile .bash_profile
_bash_profile_path = File.join(home, '.bash_profile')
profile_path = File.exist?(_bash_profile_path) ?
  _bash_profile_path :
  File.join(home, '.profile')

profile_fragment = self.get_bash_fragment(File.join(files, 'bash_profile.d'))
managed_file profile_path do
  fragment profile_fragment
  comment "#"
end

# .bashrc
bashrc_fragment = self.get_bash_fragment(File.join(files, 'bashrc.d'))
managed_file File.join(home, '.bashrc') do
  fragment bashrc_fragment
  comment "#"
end

# tmux.conf
if tmxu_use_xdg
  managed_file File.join(config_tmux, 'tmux.conf') do
    fragment "source-file #{File.join(files, 'tmux.conf')}"
    comment "#"
    insertbefore true
  end
else
  managed_file File.join(home, '.tmux.conf') do
    fragment "source-file #{File.join(files, 'tmux.conf')}"
    comment "#"
    insertbefore true
  end
end

# pip.conf
managed_file File.join(config_pip, 'pip.conf') do
  fragment <<-"EOS"
[list]
format=columns
[install]
user = no
no-warn-script-location = no
  EOS
  comment ";"
end

# config
## jesseduffield/lazydockerが優先されるので削除する
directory File.join(config, 'jesseduffield') do
  action :delete
end
%w(vifm lazydocker).each do |d|
  link File.join(config, d) do
    to File.join(files, d)
    force true
  end
end

# bin
home_bin = File.join(home, 'bin')
directory home_bin do
  action :create
end
self.dir_entries(File.join(files, 'bin')).each do |b|
  link File.join(home_bin, b) do
    to File.join(files, 'bin', b)
    force true
  end
end

# vimfiles
vimfiles = File.join(home, 'repo/github.com/nakahiro386/vimfiles')
git_clone "#{vimfiles}" do
  repository "https://github.com/nakahiro386/vimfiles.git"
end

link File.join(home, '.vim') do
  to vimfiles
end

# cykerway/complete-alias
complete_alias = File.join(home, 'repo/github.com/cykerway/complete-alias')
git_clone "#{complete_alias}" do
  repository "https://github.com/cykerway/complete-alias.git"
end

managed_file File.join(home, '.bash_completion') do
  fragment "source #{File.join(complete_alias, 'complete_alias')}"
  comment "#"
  insertbefore true
end
