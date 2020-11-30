if hash npm 2>/dev/null; then
    NPM_COMPLETION_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/npm_completion_cache"
    if [ ! -r "$NPM_COMPLETION_CACHE" ] ; then
        npm completion > "$NPM_COMPLETION_CACHE"
    fi
    source "$NPM_COMPLETION_CACHE" 
fi
