define :install_appimage, destination_dir: nil, checksum: nil, link_names: []  do
  base_name = File.basename(params[:name])
  download params[:name] do
    destination File.join(params[:destination_dir], base_name)
    user node[:target_user]
    mode "755"
    checksum params[:checksum]
  end
  params[:link_names].each do |bin|
    link File.join(params[:destination_dir], bin) do
      to base_name
      user node[:target_user]
      cwd params[:destination_dir]
      force true
    end
  end
end

install_appimage node[:vim_url] do
  checksum node[:vim_checksum]
  destination_dir File.join(node[:home], "bin")
  link_names %w(vim)
end

install_appimage node[:gvim_url] do
  checksum node[:gvim_checksum]
  destination_dir File.join(node[:home], "bin")
  link_names %w(gvim)
end

vifm_version = node[:vifm_version]
node[:vifm_url] ||= "https://github.com/vifm/vifm/releases/download/#{vifm_version}/vifm-#{vifm_version}-x86_64.AppImage"
install_appimage node[:vifm_url] do
  checksum node[:vifm_checksum]
  destination_dir File.join(node[:home], "bin")
  link_names %w(vifm)
end

tmux_version = node[:tmux_version]
node[:tmux_url] ||= "https://github.com/nelsonenzo/tmux-appimage/releases/download/#{tmux_version}/tmux.appimage"
install_appimage node[:tmux_url] do
  checksum node[:tmux_checksum]
  destination_dir File.join(node[:home], "bin")
  link_names %w(tmux)
end
