home = node[:home]
files = node[:files]

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
