_OLD_PS1="\$PS1"

if [ -r /etc/os-release ]; then
  . /etc/os-release
fi
__git_ps1_mod()
{
    if [ ${PWD:0:5} = "/mnt/" ]; then
        unset GIT_PS1_SHOWDIRTYSTATE
        unset GIT_PS1_SHOWUNTRACKEDFILES
        unset GIT_PS1_SHOWCOLORHINTS
    else
        export GIT_PS1_SHOWDIRTYSTATE=true
        export GIT_PS1_SHOWUNTRACKEDFILES=true
        export GIT_PS1_SHOWCOLORHINTS=true
    fi
    __git_ps1 "$@"
}

if [ ${ID} = "ubuntu" ]; then
  if [ "$(type -t __git_ps1)" = "function" ]; then
    PROMPT_COMMAND="__git_ps1_mod '\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]' '\n\$ '; $PROMPT_COMMAND"
  fi
elif [ ${ID} = "centos" ]; then
  git_prompt_path="/usr/share/git-core/contrib/completion/git-prompt.sh"
  if [ -r ${git_prompt_path} ]; then
    . ${git_prompt_path}
    PROMPT_COMMAND="__git_ps1_mod '[\u@\h \w]' '\n\$ '; $PROMPT_COMMAND"
  fi
  unset git_prompt_path
fi
