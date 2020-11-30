# default_values = YAML.load(File.read("#{File.dirname(__FILE__)}/anyenv.yaml"))

def dir_entries(path)
  entries = Dir.entries(path)
  entries.delete('.')
  entries.delete('..')
  return entries
end

SCRIPT_PATH = File.expand_path(__FILE__)
MITAMAE_MANAGED = /^[^\n]*mitamae managed #{Regexp.escape(SCRIPT_PATH)} START.+mitamae managed #{Regexp.escape(SCRIPT_PATH)} END\n/im

cwd = File.expand_path("..", __FILE__)
files = File.join(cwd, 'files')

p node[:platform] # => "ubuntu"
p node[:platform_version] # => "18.04"

user = ENV['USER']
user_info = node['user'][user]
p user_info
home = user_info['directory']

# dirs
config = ENV['XDG_CONFIG_HOME']
config ||= File.join(home, '.config')
config_pip = File.join(config, 'pip')
[config, config_pip].each do |d|
  directory d do
    action :create
    mode '0700'
  end
end

# git_config
git_include = <<"EOS"
; mitamae managed #{SCRIPT_PATH} START
[include]
	path = #{File.join(files, 'gitconfig')}
; mitamae managed #{SCRIPT_PATH} END
EOS

file "#{File.join(home, '.gitconfig')}" do
  action :edit
  block do |content|
    if content =~ MITAMAE_MANAGED
      content.gsub!(MITAMAE_MANAGED, git_include)
    else
      content << git_include
    end
  end
end

def add_fragment(target_file, fragment_dir)
  fragment = <<-"EOS"
# mitamae managed #{SCRIPT_PATH} START
fragment_dir="#{fragment_dir}"
if [ -d ${fragment_dir} ] ; then
    for f in ${fragment_dir}/* ; do
        [ -r "$f" ] && . "$f"
    done
    unset f
fi
unset fragment_dir
# mitamae managed #{SCRIPT_PATH} END
  EOS

  file target_file do
    action :edit
    block do |content|
      if content =~ MITAMAE_MANAGED
        content.gsub!(MITAMAE_MANAGED, fragment)
      else
        content << fragment
      end
    end
  end
end

# .profile .bash_profile
_bash_profile_path = File.join(home, '.bash_profile')
profile_path = File.exist?(_bash_profile_path) ?
  _bash_profile_path :
  File.join(home, '.profile')

profile_fragment_dir = File.join(files, 'bash_profile.d')
add_fragment(profile_path, profile_fragment_dir)

# .bashrc
bashrc_path = File.join(home, '.bashrc')
bashrc_fragment_dir = File.join(files, 'bashrc.d')
add_fragment(bashrc_path, bashrc_fragment_dir)

# tmux.conf
tmux_include = <<"EOS"
# mitamae managed #{SCRIPT_PATH} START
source-file #{File.join(files, 'tmux.conf')}
# mitamae managed #{SCRIPT_PATH} END
EOS

file "#{File.join(home, '.tmux.conf')}" do
  action :edit
  block do |content|
    unless content =~ /#{Regexp.escape(tmux_include)}/
      content << tmux_include
    end
  end
end

# pip.conf
pip_conf = <<"EOS"
; mitamae managed #{SCRIPT_PATH} START
[list]
format=columns
[install]
user = no
no-warn-script-location = no
; mitamae managed #{SCRIPT_PATH} END
EOS
file File.join(config_pip, 'pip.conf') do
  action :edit
  mode '0600'
  block do |content|
    unless content =~ /#{Regexp.escape(pip_conf)}/
      content << pip_conf
    end
  end
end

# vifm
link File.join(config, 'vifm') do
  to File.join(files, 'vifm')
  force true
end

# bin
dir_entries(File.join(files, 'bin')).each do |b|
  link File.join(home, 'bin', b) do
    to b
    force true
  end
end
