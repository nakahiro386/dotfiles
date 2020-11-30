if hash pip 2>/dev/null; then
    PIP_COMPLETION_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/pip_completion_cache"
    if [ ! -r "$PIP_COMPLETION_CACHE" ] ; then
        pip completion --bash > "$PIP_COMPLETION_CACHE"
    fi
    source "$PIP_COMPLETION_CACHE" 
fi
