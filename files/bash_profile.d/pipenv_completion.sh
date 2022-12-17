if hash pipenv 2>/dev/null; then
    PIPENV_COMPLETION_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/pipenv_completion_cache"
    if [ ! -r "$PIPENV_COMPLETION_CACHE" ] ; then
        _PIPENV_COMPLETE=bash_source pipenv > "$PIPENV_COMPLETION_CACHE"
    fi
    source "$PIPENV_COMPLETION_CACHE" 
fi
