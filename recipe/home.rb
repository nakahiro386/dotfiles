home = node[:home]
home_bin = node[:home_bin]
home_config = node[:home_config]
files = node[:files]

def self.dir_entries(path)
  entries = Dir.entries(path)
  entries.delete('.')
  entries.delete('..')
  return entries
end

directory File.join(home, ".ssh") do
  action :create
  user user
  owner user
  group user
  mode "700"
end

directory File.join(home_bin) do
  action :create
  user user
  owner user
  group user
end

ret = run_command('printf "$(tmux -V | cut -d\' \' -f2 )\n3.2" | sort -C -V', error: false)
tmxu_use_xdg = true
if ret.stderr.empty?
  tmxu_use_xdg = ret.exit_status == 1
else
  p ret.stderr
end

# dirs
xdg_user_dirs = []
local = File.join(home, '.local')
xdg_user_dirs << local
xdg_user_dirs << File.join(local, 'bin')
xdg_user_dirs << File.join(local, 'src')
xdg_user_dirs << File.join(local, 'lib')
xdg_user_dirs << ENV['XDG_DATA_HOME'] ||= File.join(local, 'share')
xdg_user_dirs << ENV['XDG_STATE_HOME'] ||= File.join(local, 'state')
xdg_user_dirs << ENV['XDG_CACHE_HOME'] ||= File.join(home, '.cache')
xdg_user_dirs << home_config

config_git = File.join(home_config, 'git')
xdg_user_dirs << config_git

config_tmux = File.join(home_config, 'tmux')
if tmxu_use_xdg
  xdg_user_dirs << config_tmux
end

config_pip = File.join(home_config, 'pip')
xdg_user_dirs << config_pip

xdg_user_dirs.each do |d|
  directory d do
    action :create
  end
end

# git_config
managed_file File.join(config_git, 'config') do
  fragment <<-"EOS"
[include]
	path = #{File.join(files, 'gitconfig')}
  EOS
  comment ";"
  insertbefore true
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

## jesseduffield/lazydockerが優先されるので削除する
directory File.join(home_config, 'jesseduffield') do
  action :delete
end
%w(vifm lazydocker).each do |d|
  link File.join(home_config, d) do
    to File.join(files, d)
    force true
  end
end

# bin
self.dir_entries(File.join(files, 'bin')).each do |b|
  link File.join(home_bin, b) do
    to File.join(files, 'bin', b)
    force true
  end
end

