zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# fzf config
eval "$(fzf --zsh)"

bg="#2A2928"
fg="#CBE0F0"
bg_highlight="#333231"
accent="#E6005F"
blue="#06BCE4"
cyan="#2CF9ED"
green="#5AF78E"

export FZF_DEFAULT_OPTS="
  --color=fg:$fg,bg:$bg,hl:$blue
  --color=fg+:$fg,bg+:$bg_highlight,hl+:$cyan
  --color=info:$accent,prompt:$green,pointer:$accent
  --color=marker:$accent,spinner:$cyan,header:$accent
"