node[:vim_packages].each do |pkg|
  package pkg
end

define :vim_build do
  dest_dir = params[:name]
  make_dir = File.join(dest_dir, "src")
  user = params[:user]

  if File.directory?(dest_dir)
    run_command("git fetch", user: user, cwd: dest_dir, log_output: true)
    current_hash = run_command("git rev-parse HEAD", user: user, cwd: dest_dir, log_output: true).stdout.chomp
    remote_hash = run_command("git rev-parse origin/master", user: user, cwd: dest_dir, log_output: true).stdout.chomp
  end

  if !File.file?(File.join(make_dir, 'vim')) || current_hash != remote_hash
    execute "git pull" do
      command "git pull"
      cwd dest_dir
      user user
    end
    execute "configure" do
      command "export CFLAGS='-Wno-deprecated-declarations' && ./configure --prefix=$HOME/.local --enable-fail-if-missing --enable-luainterp=yes --enable-python3interp=yes --with-python3-command=/usr/bin/python3 --enable-cscope --enable-terminal --enable-autoservername --enable-multibyte --enable-fontset --with-features=huge"
      cwd make_dir
      user node[:target_user]
    end
    execute "make all" do
      command "make all"
      cwd make_dir
      user node[:target_user]
    end
    execute "make install" do
      command "make install"
      cwd make_dir
      user node[:target_user]
    end
  end

end

dest_dir = File.join(node[:home], "repo/github.com/vim/vim")
git_clone dest_dir do
  repository "https://github.com/vim/vim.git"
  user node[:target_user]
end

vim_build dest_dir do
  user node[:target_user]
  not_if "! test -d #{dest_dir}"
end

