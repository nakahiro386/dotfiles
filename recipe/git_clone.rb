home = node[:home]
# dotfiles_url =  node[:dotfiles_url] ||= "git@github.com:nakahiro386/dotfiles.git"
# git_clone File.join(home, 'repo/github.com/nakahiro386/dotfiles') do
  # repository dotfiles_url
  # user user
# end

vimfiles_url =  node[:vimfiles_url] ||= "git@github.com:nakahiro386/vimfiles.git"
vimfiles = File.join(home, 'repo/github.com/nakahiro386/vimfiles')
git_clone "#{vimfiles}" do
  repository vimfiles_url
  user user
end
link File.join(home, '.vim') do
  to vimfiles
  user user
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
