vicd()
{
    # How to set shell working directory after leaving Vifm - Vifm Wiki
    # https://wiki.vifm.info/index.php?title=How_to_set_shell_working_directory_after_leaving_Vifm
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
    if [ -n "$VIM_TERMINAL" ]; then
        printf '\e]51;["call","Tapi_SyncTermCwd","%s"]\x07' "$PWD"
    fi
}
