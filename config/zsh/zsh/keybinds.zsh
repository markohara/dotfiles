source $CONFIG/functions.zsh

bindkey '^ ' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

zle -N open_sessionizer
bindkey '^F' open_sessionizer
