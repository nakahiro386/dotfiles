if hash molecule 2>/dev/null; then
    MOLECULE_COMPLETION_CACHE="${XDG_CACHE_HOME:-${HOME}/.cache}/molecule_completion_cache"
    if [ ! -r "$MOLECULE_COMPLETION_CACHE" ] ; then
        _MOLECULE_COMPLETE=bash_source molecule > "$MOLECULE_COMPLETION_CACHE"
    fi
    source "$MOLECULE_COMPLETION_CACHE"
fi
