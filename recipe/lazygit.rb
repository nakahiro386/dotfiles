define :lazygit_install, version: nil, destination_dir: nil, checksum: nil do
  version = params[:name]
  download_url = "https://github.com/jesseduffield/lazygit/releases/download/v#{version}/lazygit_#{version}_Linux_x86_64.tar.gz"

  base_name = File.basename(download_url)

  tmp_dest = File.join("/tmp", base_name)
  bin_path = File.join(params[:destination_dir], "lazygit")
  installed = FileTest.file?(bin_path) && run_command(%Q!echo "#{params[:checksum]} #{bin_path}" | sha256sum -c!, error: false).exit_status == 0

  download download_url do
    destination tmp_dest
    user node[:target_user]
    not_if { installed }
  end

  execute "Extracting to #{params[:destination_dir]}" do
    command "tar xf #{tmp_dest} -C #{params[:destination_dir]}/ lazygit"
    user node[:target_user]
    not_if { installed }
  end

  file tmp_dest do
    action :delete
  end

end

lazygit_install node[:lazygit_version] do
  checksum node[:lazygit_checksum]
  destination_dir File.join(node[:home], "bin")
end
